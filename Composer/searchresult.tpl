<?php ?>
<div class="container" action="#">
	<form action="/search" class="row">
		<div class="input-field">

		  		<i class="material-icons float_l search_icon">search</i>
					<span>
						<input id="search" class="search_bar" type="search" name="q" value="<?php echo QUERY;?>" required>
					</span>

		</div>
 	</form>
 	<h1>Profile</h1>
 	<?php
		$res = Search::forUsers( QUERY );
		foreach( $res as $itm ) {
			$s = $itm["title"];
			$a = $itm["link"];
			echo "<div class='col card-panel grey lighten-5 z-depth-1 s12 l8 offset-l2'><h5><a href='/profile/$a/'>$s</a></h5></div>";
		}
	?>
	<h1>Umfragen</h1>
	<?php
		$res = Search::forSurveys( QUERY );
		foreach( $res as $itm ) {
			$s = $itm["title"];
			$a = $itm["link"];
			echo "<div class='col card-panel grey lighten-5 z-depth-1 s12 l8 offset-l2'><h5><a href='/Surveys/$a/'>$s</a></h5></div>";
		}
	?>
	<h1>Gruppen</h1>
	<?php
		$res = Search::forGroups( QUERY );
		foreach( $res as $itm ) {
			$s = $itm["title"];
			$a = $itm["link"];
			echo "<div class='col card-panel grey lighten-5 z-depth-1 s12 l8 offset-l2'><h5><a href='/Group/$a/'>$s</a></h5></div>";
		}
	?>
</div>
