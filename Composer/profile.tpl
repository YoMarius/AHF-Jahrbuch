<?php
	$p = new Profile( PROFILEUSR );
	if( PROFILEEDIT ) echo "<form method='get' action='/profile/setValues.php'>";
?>
<br><br><br><br><br>
<div class="container">
	<div class="row">
		<div class="col s10 offset-s2 m4 offset-m4">
			<div class="card-panel grey lighten-5 z-depth-1" style="position: relative">
				<?php if(Login::isAdmin( $login_user["user_id"]) && !PROFILEEDIT ) echo '<a id="adminbutton" href="javascript:'.(Login::isAdmin(PROFILEUSR)?"revokeAdmin()\"":"grantAdmin()\" enabled").' class="btn-floating btn-large waves-effect waves-light red right" style="position: absolute; top: -9%; right: -9%"><i class="material-icons">star</i></a>' ?>
				<?php if(PROFILEUSR == $login_user["user_id"] && !PROFILEEDIT ) echo '<a href="./edit" class="btn-floating btn-large waves-effect waves-light red right" style="position: absolute; top: -9%; right: -9%"><i class="material-icons">edit</i></a>' ?>
				<ul class="tabs" style="margin-bottom:5px;">
					<li class="tab col s6"><a href="#profilbild">Profil-</a></li>
					<li class="tab col s6"><a href="#kinderbild">Kinderbild</a></li>
				</ul>
				<div id="profilbild"><a <?php if( PROFILEUSR == $login_user["user_id"] ) echo 'href="#uploadview" class="modal-trigger"';?> style="position: relative"><img src="<?php echo $p->getAvatar(); ?>" alt="" class="circle responsive-img"><?php if( PROFILEUSR == $login_user["user_id"] ) echo '<i style="position: absolute; bottom: 1%; right: 1%;" class="material-icons">backup</i>';?></a></div>
				<div id="kinderbild"><a <?php if( PROFILEUSR == $login_user["user_id"] ) echo 'href="#uploadviewkind" class="modal-trigger"';?> style="position: relative"><img src="<?php echo $p->getAvatar('_kind'); ?>" alt="" class="circle responsive-img"><?php if( PROFILEUSR == $login_user["user_id"] ) echo '<i style="position: absolute; bottom: 1%; right: 1%;" class="material-icons">backup</i>';?></a></div>
				<h4 class="center"><?php if( !PROFILEEDIT ) echo $p->getFirstName()." ".$p->getLastName();
										 else echo "<input name='firstname' value='".$p->getFirstName()."' /><input name='lastname' value='".$p->getLastName()."' />";?></h4></div>
		</div>
     </div>
    <?php
     	$fields = $p->getFields();
     	foreach( $fields as $field ) {
     		$title = $field["field_title"];
     		$value = $field["value"];
     		echo'
			 	<div class="row row_profil">
					<div class="col s6">
						<p class="right green-text">'.$title.'</p>
					</div>
				<div class="col s6">';
		if( PROFILEEDIT ) {
			switch( $field["field_type"] ) {
				case 1: echo '<input class="left" name="'.$field["field_id"].'" value="'.$value.'">'; break;
				case 2: foreach( explode( "|", $field["field_opt"] ) as $k=>$str ) echo '<input name="'.$field["field_id"].'"   type="radio"    id="'.$field["field_id"].$k.'" value="'.$k.'" '.($value==$str?                      "checked":"").'/><label style="margin-right: 1%" for="'.$field["field_id"].$k.'">'.$str.'</label> '; break;
				case 3: foreach( explode( "|", $field["field_opt"] ) as $k=>$str ) echo '<input name="'.$field["field_id"].'[]" type="checkbox" id="'.$field["field_id"].$k.'" value="'.$k.'" '.(in_array($str,explode("|",$value))?"checked":"").'/><label style="margin-right: 1%" for="'.$field["field_id"].$k.'">'.$str.'</label> '; break;
				case 4: echo '<textarea class="left materialize-textarea" name="'.$field["field_id"].'">'.$value.'</textarea>'; break;
			}
		}
		else {
			switch( $field["field_type"] ) {
				case  1: echo '<p class="left">'.$value.'</p>'; break;
				case  2: echo '<p class="left">'; echo $field["value"]; echo "</p>"; break;
				case  3: echo '<p class="left">'; foreach( explode( "|", $field["value"] ) as $str ) echo '<div class="chip">'.$str.'</div>'; echo '</p>'; break;
				case  4: echo '<p class="left">'.$value.'</p>'; break;
				default: break;
			}

     	}
     	echo '</div></div>';
     	}
     	if( PROFILEEDIT ) echo '<br><br>
     	<div class="row" onclick="document.forms[0].submit()">
     		<input type="submit" value="Speichern" id="loginbutton" class="waves-effect waves-light btn green col s12 m4 offset-m4">
     	</div>
     	</form>
     	<br><br>';

     ?>
     <div class="row">
     <h2>Gruppen</h2>
     	<?php
     	foreach(Group::inGroups(PROFILEUSR) as $group ) {
     		$name = $group["name"];
			$lnk = "/group/".$group["group_id"]."/";
			echo "
			<a href='$lnk' class='col s6 m3' style=\"padding: 2%\">
				<div class='card-panel grey lighten-5 z-depth-1'>
					<h4 class=\"center\">$name</h4>
				</div>
			</a>";
		}
		?>
     </div>
     <div id="uploadview" class="modal bottom-sheet">
    <div class="modal-content">
      <h4>Profilbild hochladen:</h4>
      <?php Upload::showUploadSection('profil');?>
    </div>
    <div class="modal-footer">
      <a href="#!" class="modal-action modal-close waves-effect waves-green btn-flat ">Abbrechen</a>
    </div>
  </div>
	<div id="uploadviewkind" class="modal bottom-sheet">
	    <div class="modal-content">
	      <h4>Profilbild hochladen:</h4>
	      <?php Upload::showUploadSection('profilkind');?>
	    </div>
	    <div class="modal-footer">
	      <a href="#!" class="modal-action modal-close waves-effect waves-green btn-flat ">Abbrechen</a>
	    </div>
	  </div>
     <script>
     $(document).ready(function(){
    // the "href" attribute of .modal-trigger must specify the modal ID that wants to be triggered
    $('.modal').modal();
  	});
     var adb = document.getElementById( "adminbutton" )
     function grantAdmin() {
     	var x = new XMLHttpRequest()
     	x.open( "GET", "/JSON/grantadmin/?user=<?php echo PROFILEUSR; ?>"  );
     	x.onreadystatechange = function() {
     		if( x.readyState == 4 ) {
     			var a = eval(x.responseText);
     			if( a ) { adb.href="javascript:revokeAdmin()"; adb.removeAttribute("enabled")}
     			else    { adb.href="javascript:grantAdmin()";  adb.setAttribute("enabled","")}
     		}
     	}
     	x.send();
     }
     function revokeAdmin() {
     	var x = new XMLHttpRequest()
     	x.open( "GET", "/JSON/revokeadmin/?user=<?php echo PROFILEUSR; ?>" );
     	x.onreadystatechange = function() {
     		if( x.readyState == 4 ) {
     			var a = eval(x.responseText);
     			if( a ) { adb.href="javascript:revokeAdmin()"; adb.removeAttribute("enabled")}
     			else    { adb.href="javascript:grantAdmin()";  adb.setAttribute("enabled","")}
     		}
     	}
     	x.send();
     }
     </script>
     <style>
     	#adminbutton {
     		background: grey !important;
     	}
     	#adminbutton[enabled] {
     		background: #ffeb3b !important;
     	}
     </style>
</div>
