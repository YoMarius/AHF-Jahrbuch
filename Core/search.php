<?php require_once( "db.php" );
	class Search {
		
		public static function forUsers( $q ) {
			if(!($db = connectDB()) ) return false;
			if(!($result = $db->query( "SELECT CONCAT(`FName`,' ' ,`LName`) as `title`, `user_id` as `link` FROM `profiles` WHERE CONCAT(`FName`,' ' ,`LName`) Like '%$q%'" ) ) ) return false;
			$ret = []; while(($e = $result->fetch_array(MYSQL_ASSOC))) { $ret[] = $e; }
			return $ret;
		}
		public static function forSurveys( $q ) {
			if(!($db = connectDB()) ) return false;
			if(!($result = $db->query( "SELECT `survey_title` as `title`, `survey_meta_id` as `link` FROM `survey_meta` WHERE `survey_visible` Like 1 AND `survey_title` Like '%$q%'" ) ) ) return false;
			$ret = []; while(($e = $result->fetch_array(MYSQL_ASSOC))) { $ret[] = $e; }
			return $ret;
		}
		public static function forGroups ( $q ){
                if(!($db = connectDB()) ) return false;
                if(!($result = $db->query( "SELECT `name` as `title`, `group_id` as `link` FROM `group_meta` WHERE `name` Like '%$q%'") ) ) return false;
                $ret = []; while(($e = $result->fetch_array(MYSQL_ASSOC))) { $ret[] = $e; }
                return $ret;
        }
		public static function highlightString( $string, $query ) {
			$i = 0; $n = strlen( $query );
			while( $i !== False ) {
				if( ( $i = stripos( $string, $query, $i ) ) === False ) break;
				$sub = "<span class='green-text text-lighten-1'>".substr( $string, $i, $n )."</span>";
				$string = substr_replace( $string, $sub, $i, $n );
				$i += strlen( $sub );
			}
			return $string;
		}
		
	}
?>
