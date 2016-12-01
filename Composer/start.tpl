<?php ?>
<div class='container' action='#'>
	<div class='row'>
		<?php if (Login::isAdmin(Login::checkUser()['user_id'])){ ?>
			<div class='col s6'>
				<ul class='collection with-header'>
					<li class='collection-header'><h5>Benutzer (<?php $profiles = Profile::listProfiles( ); echo count( $profiles ) ?>)</h5></li>
						<div class='dashboard_info_container'>
			    <?php
						foreach( $profiles as $itm ) {
							$name = $itm['FName']." ".$itm['LName'];
							$id = $itm['user_id'];
							echo "
							<a href='/profile/$id/'><li class='collection-item '>
								<h5><i class='material-icons left'>account_circle</i><span class='title'>$name</span></h5>
							</li></a>
							";
						}
						?>
						</div>
			  </ul>
			</div>
			<div class='col s6'>
				<ul class='collection with-header'>
					<li class='collection-header'><h5>Log's</h5></li>
					<div class='dashboard_info_container'>
					<?php
						$res = Log::getMessages( );
						foreach( $res as $itm ) {
							$name = $itm['name'];
							$content = $itm['content'];
							$date = $itm['date'];
							echo "
							<li class='collection-item'>
								<span class='title grey-text'>[$name]</span> <span>$content</span> <span class='light-green-text right'>($date)</span>
								</p>
							</li>
							";
						}
						?>
					</div>

				</ul>
			</div>
			<div class='col s12'>
				<ul class="tabs">
					<li class="tab col s6"><a href="#surveys" class="active">Umfragen (<?php $surveys = Survey::getSurveys( false ); echo count( $surveys ) ?>)</a></li>
					<li class="tab col s6"><a href="#groups">Gruppen (<?php $groups = Group::getGroups(); echo count( $groups ) ?>)</a></li>
				</ul>
				<div id="surveys" class="col s12">
						<ul class='collection'>
							<div class='dashboard_info_container'>
							<?php

								foreach( $surveys as $itm ) {
									$title = $itm['survey_title'];
									$desc = $itm['survey_description'];
									$id = $itm['survey_meta_id'];
									echo "

									<a href='/Surveys/$id/'><li class='collection-item'>
										<b class='title'>$title</b>
										<p>$desc</p>
									</li></a>

									";
								}
								?>
							</div>

						</ul>
					</div>
					<div id="groups" class="col s12">
						<ul class='collection with-header'>
							<div class='dashboard_info_container'>
							<?php

								foreach( $groups as $itm ) {
									$name = $itm['name'];
									$desc = $itm['description'];
									$id = $itm['group_id'];
									echo "
									<a href='/group/$id/'><li class='collection-item'>
										<b class='title'>$name</b>
										<p>$desc</p>
									</li></a>
									";
								}
								?>
							</div>

						</ul>
					</div>

			</div>
		<?php }else{ ?>
		<h1 class='center s12 l8 offset-l2'>Jahrbuch seite des MH27 Abschluss Jahres</h1>
		<h5 class='center s12 l8 offset-l2'>Logge dich ein oder registriere dich ( 4 free ) um den vollen inhalt zu genießen.<br>Das desing is ( schlampig ) mit http://materializecss.com/navbar.html gemacht, so schlampig das hier ne verlinkung fehlt.</h5>
		<?php } ?>
	</div>

</div>
