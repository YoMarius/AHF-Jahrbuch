<?php
	$group = new Group( GROUP );
	$usr = $login_user["user_id"];
?>
<br><br><br><br>
<div class="container">
	<img src="http://i.imgur.com/jtkTPvb.gif" class="right" id="loading">
	<div class="row">
		<div class="col s10 offset-s2 m4 offset-m4">
			<h1 class="center"><?php echo $group->getName(); ?></h1>
			<h5 class="center">- <?php echo $group->getDescription(); ?> -</h5>
		</div>
     </div>
     <div class="row">
			 <div class='col s12'>
 				<ul class="tabs">
 					<li class="tab col s6"><a href="#surveys" class="active">Mitglieder (<?php $group->getMembers( false ); echo count( $group ) ?>)</a></li>
 					<li class="tab col s6"><a href="#groups">Bilder</a></li>
 				</ul>
 				<div id="surveys" class="col s12" style="margin: 0 auto;">
					<?php if( Group::isMod($group, $usr) ) { ?>
					<a  href="#adduserview" class="waves-effect waves-light btn center modal-trigger" style="width: 49%;"><i class="material-icons left">add</i>Benutzer hinzufügen</a>
					<a  href="#addremoveuserview" class="waves-effect waves-light btn center modal-trigger" style="width: 49%; "><i class="material-icons left">remove</i>Benutzer löschen</a>
					<a  href="#addgrantuserview" class="waves-effect waves-light btn center modal-trigger" style="width: 49%;margin-top: 5px"><i class="material-icons left">add</i>Moderator ernnen</a>
					<a  href="#revokegrantuserview" class="waves-effect waves-light btn center modal-trigger" style="width: 49%;margin-top: 5px"><i class="material-icons left">remove</i>Moderator entfernen</a>
					<?php } ?>
 						<ul class='collection'>
 							<div >

								<?php
								foreach($group->getMembers() as $member ) {
									$name = $member->getFirstName()." ".$member->getLastName();
									$id = $member->getID();
								echo "
								<div class='col s6 m3' style=\"padding: 2%\">
									<div class='card-panel grey lighten-5 z-depth-1'>
										<img src=\"/media/img/$id/profilbild\" class=\"circle responsive-img\">
										<h4 class=\"center\">$name</h4>
									</div>
								</div>";
								}
								?>
 							</div>

 						</ul>
 					</div>
 					<div id="groups" class="col s12">
 						<ul class='collection with-header'>
 							<div align="center">
							<a  href="#uploadview" class="waves-effect waves-light btn center modal-trigger" style="width: 100%;"><i class="material-icons left">cloud</i>Bilder hochladen</a>
 							</div>
							<div id="gallery">
							<?php
						try{
							$dir = new DirectoryIterator('../media/img/'.$group->getID());
							foreach ($dir as $fileinfo) {
									if (!$fileinfo->isDot()) {
										$path = '/media/img/';
										$path .= $group->getID().'/';
										$path .= $fileinfo->getFilename();

										?>
											<img src="<?php echo $path ?>" class="materialboxed responsive-img" style="margin:0" alt=""  width="200px" width="200px">
											<?php
									}
							}

						}catch(Exception $e)
						{
						}

							?>
						</div>
 						</ul>
 					</div>

 			</div>
     </div>
</div>
</div>
<div id="uploadview" class="modal bottom-sheet">
    <div class="modal-content">
      <h4>Profilbild hochladen:</h4>
      <?php Upload::showUploadSection('group', $group->getID());?>

    </div>
    <div class="modal-footer">
      <a href="#!" class="modal-action modal-close waves-effect waves-green btn-flat ">Abbrechen</a>
    </div>
  </div>
	<div id="adduserview" class="modal bottom-sheet">
	    <div class="modal-content">
	      <h4>Benutzer hinzufügen:</h4>
	      <?php
				$res = Profile::listProfiles(  );
				$gid = $group->getID();
				$_POST = array();
				foreach( $res as $itm ) {
					$name = $itm["FName"]." ".$itm["LName"];
					$link = $itm["user_id"];
					echo "
					<form action=\"/Group/setValues.php\" id=\"addmem\" method=\"post\">
						<input type=\"text\" style=\"display:none;\" id=\"addmember\" name=\"addmember\" value=\"$link\"  />
						<input type=\"text\" style=\"display:none;\" id=\"group\" name=\"group\" value=\"$gid\"  />
						<input type=\"submit\" id=\"submember\" class=\"waves-effect waves-light btn center\" name=\"submit\" value=\"$name\" />
					</form>
					";
				}?>
	    </div>
	    <div class="modal-footer">
	      <a href="#!" class="modal-action modal-close waves-effect waves-green btn-flat ">Abbrechen</a>
	    </div>
	  </div>
		<div id="addremoveuserview" class="modal bottom-sheet">
				<div class="modal-content">
					<h4>Benutzer löschen:</h4>
					<?php
					$_POST = array();
					$gid = $group->getID();
					$res = $group->getMembers( );
					foreach( $res as $itm ) {
						$name = $itm->getFirstName()." ".$itm->getLastName();
						$link = $itm->getID();
						echo "
						<form action=\"/Group/setValues.php\" id=\"remmem\" method=\"post\">
							<input type=\"text\" style=\"display:none;\" id=\"removeMember\" name=\"removeMember\" value=\"$link\"  />
							<input type=\"text\" style=\"display:none;\" id=\"group\" name=\"group\" value=\"$gid\"  />
							<input type=\"submit\" id=\"remmember\" class=\"waves-effect waves-light btn center\" name=\"submit\" value=\"$name\" />
						</form>
						";
					}?>
				</div>
				<div class="modal-footer">
					<a href="#!" class="modal-action modal-close waves-effect waves-green btn-flat ">Abbrechen</a>
				</div>
			</div>
			<div id="addgrantuserview" class="modal bottom-sheet">
					<div class="modal-content">
						<h4>Benutzer als Moderator ernennen:</h4>
						<?php
						$_POST = array();
						$gid = $group->getID();
						$res = $group->getMembers( );
						foreach( $res as $itm ) {
							$name = $itm->getFirstName()." ".$itm->getLastName();
							$link = $itm->getID();
							echo "
							<form action=\"/Group/setValues.php\" id=\"grantMod\" method=\"post\">
								<input type=\"text\" style=\"display:none;\" id=\"grantMod\" name=\"grantMod\" value=\"$link\"  />
								<input type=\"text\" style=\"display:none;\" id=\"group\" name=\"group\" value=\"$gid\"  />
								<input type=\"submit\" id=\"grantModbtn\" class=\"waves-effect waves-light btn center\" name=\"submit\" value=\"$name\" />
							</form>
							";
						}?>
					</div>
					<div class="modal-footer">
						<a href="#!" class="modal-action modal-close waves-effect waves-green btn-flat ">Abbrechen</a>
					</div>
				</div>
				<div id="revokegrantuserview" class="modal bottom-sheet">
						<div class="modal-content">
							<h4>Benutzer als Moderator entfernen:</h4>
							<?php
							$_POST = array();
							$gid = $group->getID();
							$res = $group->getMembers( );
							foreach( $res as $itm ) {
								if(Group::hasModPriv($gid, $itm->getID())){
								$name = $itm->getFirstName()." ".$itm->getLastName();
								$link = $itm->getID();
								echo "
								<form action=\"/Group/setValues.php\" id=\"revokeMod\" method=\"post\">
									<input type=\"text\" style=\"display:none;\" id=\"revokeMod\" name=\"revokeMod\" value=\"$link\"  />
									<input type=\"text\" style=\"display:none;\" id=\"group\" name=\"group\" value=\"$gid\"  />
									<input type=\"submit\" id=\"revokeModbtn\" class=\"waves-effect waves-light btn center\" name=\"submit\" value=\"$name\" />
								</form>
								";
							}}?>
						</div>
						<div class="modal-footer">
							<a href="#!" class="modal-action modal-close waves-effect waves-green btn-flat ">Abbrechen</a>
						</div>
					</div>
