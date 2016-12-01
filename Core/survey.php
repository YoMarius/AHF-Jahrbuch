<?php require_once( "db.php" );

define( "SURVEY_MYSQL_ERROR", 0 );
define( "SURVEY_NOT_FOUND", 1 );
define( "SURVEY_NOT_VISIBLE", 2 );

	class Survey {

	//#######
	//#
	//#	    Holds the error code
	//#
	//#######
	private $error;

	//#######
	//#
	//#	    Returns the error code
	//#
	//#######
	public function getError() { return $this->error; }

	//#######
	//#
	//#	    Returns the error message
	//#
	//#######
	public function getErrorMessage() {
		switch( $this->error ) {
			case SURVEY_NOT_VISIBLE          : return "Diese Umfrage ist momentan nicht Verfügbar";
			case SURVEY_NOT_FOUND            : return "Diese Umfrage Existiert nicht";
			case SURVEY_MYSQL_ERROR          : return "Es gibt ein Problem mit der Datenbank";
		}
	}

    //#######
	//#
	//#	    Returns list of all avaiable survey, optional also hidden ones
	//#
	//#######
	public static function getSurveys( $hideInvisible=true ) {
		if(!($db = connectDB()) ) return false;
		if(!($result = $db->query( "SELECT * FROM `survey_meta` WHERE ".($hideInvisible?"`survey_visible` Like 1":"1") ) ) ) return false;
		$ret = []; while(($e = $result->fetch_array(MYSQL_ASSOC))) { $ret[] = $e; }
		return $ret;
	}
	//#######
	//#
	//#	    Returns single survey by id, same as new Survey([id])
	//#
	//#######
	public static function getSurvey( $id, $u = false ) {
		return new Survey( $id, $u );
	}
	//#######
	//#
	//#	    Surveys meta data
	//#
	//#######
	protected $id = "";
	protected $title = "";
	protected $description = "";
	protected $visible = false;
	protected $questions = [];

	public function getID() { return $this->id; }
	public function getTitle() { return $this->title; }
	public function getDescription() { return $this->description; }
	public function isPublic() { return $this->visible; }
	public function getQuestions() { return $this->questions; }

	//#######
	//#
	//#	    Sets title and description of the survey
	//#
	//#######
	public function setMeta( $title, $description, $visible ) {
		$visible = $visible?1:0;
		if(!($db = connectDB()) ) {error_log($db->error); return SURVEY_MYSQL_ERROR;}
		if(!($result = $db->query("UPDATE `survey_meta` SET `survey_title`='$title', `survey_description`='$description', `survey_visible`=$visible WHERE `survey_meta_id` Like ".$this->id) ) ) {$this->error=SURVEY_MYSQL_ERROR; return false;}
		$this->loadMeta();
		return true;
	}
	//#######
	//#
	//#	    Internal function to load the meta data
	//#
	//#######
	protected function loadMeta() {
		if(!($db = connectDB()) ) {error_log($db->error); return SURVEY_MYSQL_ERROR;}
		$id = $this->id; if(!($result = $db->query("SELECT * FROM `survey_meta` WHERE `survey_meta_id` Like $id") ) ) {$this->error=SURVEY_MYSQL_ERROR; return false;}
		if( $result->num_rows == 0 )  {$this->error=SURVEY_NOT_FOUND; return false;}
		$result = $result->fetch_array(MYSQL_ASSOC);
		$this->title       = $result["survey_title"];
		$this->description = $result["survey_description"];
		$this->visible     = $result["survey_visible"]==1;
		return true;
	}
	//#######
	//#
	//#	    Internal function to load the questions
	//#
	//#######
	protected function loadQuestions( $user_id = false ) {
		$id = $this->id;
		if( $user_id ) $q = "SELECT `question_id`, `question_title`,  COALESCE( `votes`, 0 ) as `votes`, `myvote` FROM `survey_questions` LEFT JOIN ( SELECT *, SUM( `vote_value` ) as votes FROM `survey_votes` LEFT JOIN ( SELECT `vote_value` As myvote, `vote_user` as user, `vote_question` as id FROM `survey_votes` WHERE `vote_user` Like '$user_id' ) as OwnVotes ON `vote_question` Like id GROUP BY `vote_question`) as votes ON `vote_question` LIKE `question_id` WHERE `survey_id` Like $id ORDER BY `votes` DESC";
		else $q = "SELECT `question_id`, `question_title`, SUM(`vote_value`) As votes FROM `survey_votes`, `survey_questions` WHERE `survey_id` Like $id AND `vote_question` Like `question_id` GROUP BY `vote_question` ORDER BY `votes` DESC";
		if(!($db = connectDB()) ) {error_log($db->error); return SURVEY_MYSQL_ERROR;}
		if(!($result = $db->query( $q ) ) ) {$this->error=SURVEY_MYSQL_ERROR; return false;}
		if( $result->num_rows == 0 )  {$this->error=SURVEY_NOT_FOUND; return false;}
		$ret = []; while(($e = $result->fetch_array(MYSQL_ASSOC))) { $ret[] = $e; }
		$this->questions = $ret;
	}
	//#######
	//#
	//#	    Removes a specific question
	//#
	//#######
	public function removeQuestion( $id ) {
		if(!($db = connectDB()) ) {error_log($db->error); return SURVEY_MYSQL_ERROR;}
		if(!($result = $db->query("DELETE FROM `survey_questions` WHERE `question_id` Like $id") ) ) {$this->error=SURVEY_MYSQL_ERROR; return false;}
		$this->loadQuestions();
		return true;
	}
	//#######
	//#
	//#	    Adds a question to the survey
	//#
	//#######
	public function addQuestion(  $title ) {
		if(!($db = connectDB()) ) {error_log($db->error); return SURVEY_MYSQL_ERROR;}
		$id = $this->id;
		if(!($result = $db->query("INSERT INTO `survey_questions` (survey_id,question_title) VALUES ($id, '$title' );") ) ) {$this->error=SURVEY_MYSQL_ERROR; return false;}
		$this->loadQuestions();
		return true;
	}
	//#######
	//#
	//#	    Set title/subject of specific question
	//#
	//#######
	public function editQuestion( $id, $title ) {
		echo "UPDATE `survey_questions` SET `question_title`=$title WHERE `question_id` Like '$id'";
		if(!($db = connectDB()) ) {error_log($db->error); return SURVEY_MYSQL_ERROR;}
		if(!($result = $db->query("UPDATE `survey_questions` SET `question_title`='$title' WHERE `question_id` Like '$id'") ) ) {$this->error=SURVEY_MYSQL_ERROR; return false;}
		$this->loadQuestions();
		return true;
	}
	//#######
	//#
	//#	    Composes loading of meta and questions
	//#
	//#######
	public function Survey( $id, $uid = false ) {
		$this->id = $id;
		$this->loadMeta();
		$this->loadQuestions( $uid );
	}
	//#######
	//#
	//#	    Deletes a Survey
	//#
	//#######
	public static function deleteSurvey( $id ) {
		if(!($db = connectDB()) ) return false;
		if(!($db->query("DELETE FROM `survey_meta`      WHERE `survey_meta_id` Like $id") ) ) return false;
		if(!($db->query("DELETE FROM `survey_questions` WHERE `survey_id`  Like $id") ) ) return false;
		if(!($db->query("DELETE FROM `survey_votes`     WHERE `survey__id` Like $id") ) ) return false;
		return true;
	}
	//#######
	//#
	//#	    Creates and returns a new Survey
	//#
	//#######
	public static function createSurvey( $title, $description ) {
		if(!($db = connectDB()) ) return false;
		if(!($result = $db->query("INSERT INTO `survey_meta` ( `survey_title`, `survey_description` ) VALUES ( '$title', '$description' )") ) ) return false;
		return new Survey( $db->query("SELECT LAST_INSERT_ID()")->fetch_array(MYSQL_NUM)[0] );
	}
	//#######
	//#
	//#	    UP/NEUTRAL/DOWNVOTES a question
	//#
	//#######
	public static function vote( $question_id, $user_id, $vote ) {
		if(!($db = connectDB()) ) {error_log($db->error); return SURVEY_MYSQL_ERROR;}
		if(!($result = $db->query( "SELECT 1 FROM `survey_votes` WHERE `vote_user` LIKE '$user_id' AND `vote_question` Like '$question_id' ") ) ) {$this->error=SURVEY_MYSQL_ERROR;return false;}
		if(!($rslt = $db->query( "SELECT `survey_id` FROM `survey_questions` WHERE `question_id` Like '$question_id' ") ) ) {$this->error=SURVEY_MYSQL_ERROR;return false;}
		$survey_id=$rslt->fetch_array(MYSQL_NUM)[0];
		if($result->num_rows == 0) { if(!($x = $db->query( "INSERT INTO `survey_votes` ( `vote_user`, `vote_question`, `vote_value`, `survey__id` ) VALUES ( '$user_id', '$question_id', $vote, $survey_id )") ) ) {return false; } }
		else                       { if(!($x = $db->query( "UPDATE `survey_votes` SET `vote_value`=$vote WHERE `vote_user` LIKE '$user_id' AND `vote_question` Like '$question_id'") ) ) {return false;} }
		return $db->query( "SELECT ownvote, SUM( `vote_value` ) as votes, '$question_id' as question FROM (SELECT `vote_value` as ownvote FROM `survey_votes` WHERE `vote_question` LIKE $question_id AND `vote_user` LIKE '$user_id') as ov, `survey_votes` WHERE `vote_question` LIKE $question_id" )->fetch_array(MYSQL_ASSOC);
	}

}


?>
