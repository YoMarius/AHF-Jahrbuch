<?php
	$s = new Survey( SURVEY, $login_user["user_id"] );
	$survey_id = $s->getID();
	if( SURVEYEDIT ) echo '<form method="POST" action="/Surveys/setValues.php" id="editform">';
?>
<div class="container" action="#">
<div class="row">
<h1 class="center s12 l8 offset-l2"><?php if( SURVEYEDIT ) echo "<input type='text' name='title' value='".$s->getTitle()."'>"; else echo $s->getTitle();?></h1>
<h5 class="center s12 l8 offset-l2">- <?php if( SURVEYEDIT ) echo "<input type='text' name='desc'  value='".$s->getDescription()."'>"; else echo $s->getDescription(); ?> -</h5>
<?php
if( !SURVEYEDIT && Login::isAdmin( $login_user["user_id"] ) ) {
		echo '<ul><li><a href="delete/" class="btn-floating btn-large waves-effect waves-light red"><i class="material-icons">delete</i></a>
			  <a href="edit/" class="btn-floating btn-large waves-effect waves-light orange"><i class="material-icons">edit</i></a></li></ul>';
	}
?>
<br><br><br><br><br>
<?php
	if( SURVEYEDIT ) {
		echo "<p class='center green-text lighten-1'>Leave blank to delete</p><script>
				function save() {
					document.getElementById('editform').submit();
				}
				function add() {
					var o = document.createElement('div');
					document.getElementById('questions').insertBefore( o, document.getElementById('questions').childNodes[0]);
					o.outerHTML = \"<div class='col card-panel grey lighten-5 z-depth-1 s12 l8 offset-l2'><h4><input name='new[]' type='text' value=''></h4></div>\";
				}
			</script>";
		echo '<ul><li><a href="javascript:add()" class="btn-floating btn-large waves-effect waves-light red"><i class="material-icons">add</i></a>
			  <a href="javascript:save()" class="btn-floating btn-large waves-effect waves-light orange"><i class="material-icons">save</i></a>
			  <a href="/Surveys/'.SURVEY.'/" class="btn-floating btn-large waves-effect waves-light blue"><i class="material-icons">list</i></a><a href="../delete/" class="btn-floating btn-large waves-effect waves-light red"><i class="material-icons">delete</i></a></li></ul>
		<input type="hidden" value="'.SURVEY.'" name="survey_id"><input id="muckefuck" type="checkbox" name="visib" '.($s->isPublic()?"checked":"").'><label style="margin-right: 1%" for="muckefuck">Öffentlich</label><div id="questions">';
	}
	foreach( ($s->getQuestions()) as $question ) {
		$id     = $question["question_id"];
		$title  = $question["question_title"];
		$votes  = $question["votes"]?$question["votes"]:0;
		$myvote = $question["myvote"];
		$up = $myvote==1 ?"light-green-text":"";
		$down = $myvote==-1?"red-text":"";
		if( SURVEYEDIT ) echo "<div class='col card-panel grey lighten-5 z-depth-1 s12 l8 offset-l2'><h4><input name='$id' type='text' value='$title'></h4></div>";
		else echo "<div id='$id' class='col card-panel grey lighten-5 z-depth-1 s12 l8 offset-l2'><h4><span style='float: right'><span id='votes_$id' class='votes'>$votes</span><a id='up_$id' href='javascript:vote($id,1)' style='font-size: inherit' class='material-icons $up'>expand_less</a><a id='down_$id' href='javascript:vote($id,-1)' style='font-size: inherit' class='material-icons $down'>expand_more</a></span>$title</h4></div>";
	}
	if( SURVEYEDIT ) echo "</div></form>";
?>
</div>
<script>
	function vote( question, value ) {
		var x = new XMLHttpRequest()
		x.open( "GET", "/JSON/vote?value="+value+"&question="+question )
		x.onreadystatechange = function () {
			console.log( x.readystate )
			if( x.readyState != 4 ) return
			eval( "r = "+x.responseText )
			if( r ) {
				document.getElementById( "votes_"+r.question ).innerText = r.votes
				if( r.ownvote == 1 ) {
					document.getElementById( "up_"+r.question ).setAttribute( "class", "material-icons light-green-text" )
					document.getElementById( "down_"+r.question ).setAttribute( "class", "material-icons" )
				}
				else {
					document.getElementById( "up_"+r.question ).setAttribute( "class", "material-icons" )
					document.getElementById( "down_"+r.question ).setAttribute( "class", "material-icons red-text" )
				}
			}
			var questions = document.getElementById( "questions" )
			var o = document.getElementById( r.question ).cloneNode(true)
			questions.removeChild(document.getElementById( r.question ))
			for( i = 0; i < questions.children.length; i++ ) {
				e = questions.children[i]
				if( e.getElementsByClassName( "votes" )[0].innerText*1 < r.votes*1 ) {
					questions.insertBefore( o, e )
					return
				}
			}
			questions.appendChild( o )
		}
		x.send();
	}
</script>
</div>
</div>
