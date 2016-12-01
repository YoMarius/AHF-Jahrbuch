<?php ?>
<h1 class="center">Umfragen</h1>
<div class="container" action="#">
<div class="row">
<?php
	$isAdmin = $login_user["user_id"];
	foreach( (Survey::getSurveys(!$isAdmin)) as $survey ) {
		$id     = $survey["survey_meta_id"];
		$title  = $survey["survey_title"];
		$desc   = $survey["survey_description"];
		$visible= $survey["survey_visible"]?"":"<i class='material-icons'>lock</i>";
		echo "<div class='col card-panel grey lighten-5 z-depth-1 s12 l8 offset-l2'><h2><a href='$id'>$visible $title</a></h2><p>$desc</p></div>";
	}
	if( $isAdmin ) echo "<form class='col s12 l8 offset-l2' method='post' action='/Surveys/setValues.php'><input class='btn green' type='submit' name='addSurvey' value='Add a new One!'></form>";
?>
</div>
</div>
