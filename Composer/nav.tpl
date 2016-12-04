<?php ?>
<nav>
	<div class="nav-wrapper light-green">
		<a href="/index.php/" class="brand-logo"><?php echo Login::isAdmin(Login::checkUser()["user_id"])?"Dashboard<i class='material-icons'>dashboard</i>":"Jahrbuch"; ?></a>
		<a href="#" data-activates="mobile-demo" class="button-collapse"><i class="material-icons">menu</i></a>
		<ul class="right hide-on-med-and-down">
			<?php if(Login::checkUser()){?>
			<li><a href="/search/"><i class="material-icons left">search</i>Suche</a></li>
			<li><a href="/Surveys/"><i class="material-icons left">assignment</i>Umfragen</a></li>
			<?php }?>
			<li><a href="<?php $user = Login::checkUser(); echo $user?"/profile/".$user["user_id"]:"/Signin/" ?>"><i class="material-icons left">account_circle</i><?php $user = Login::checkUser();if( $user ) { $u = new Profile( $user["user_id"] ); echo $u->getFirstName()." ".$u->getLastName(); } else { echo "Anmelden"; } ?></a></li>
			<?php if(Login::checkUser()){?>
			<li><a href="/Signout/"><i class="material-icons left">exit_to_app</i>Ausloggen</a></li>
			<?php }?>
		</ul>
		<ul class="side-nav" id="mobile-demo">
			<?php if(Login::checkUser()){?>
			<li><a href="/search/"><i class="material-icons left">search</i>Suche</a></li>
			<li><a href="/Surveys/"><i class="material-icons left">assignment</i>Umfragen</a></li>
			<?php }?>
			<li><a href="<?php $user = Login::checkUser(); echo $user?"/profile/".$user["user_id"]:"/Signin/" ?>"><i class="material-icons left">account_circle</i><?php $user = Login::checkUser();if( $user ) { $u = new Profile( $user["user_id"] ); echo $u->getFirstName()." ".$u->getLastName(); } else { echo "Anmelden"; } ?></a></li>
			<?php if(Login::checkUser()){?>
			<li><a href="/Signout/"><i class="material-icons left">exit_to_app</i>Ausloggen</a></li>
			<?php }?>
		</ul>
	</div>
	<style>
		.side-nav li {
			width: 100%;
			float: left;
		}
	</style>
</nav>
