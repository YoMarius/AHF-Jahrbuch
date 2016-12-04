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
 	<?php
 		if( QUERY ) {
 			$res = Search::forUsers( QUERY );
 			$n = count( $res );
 			if( count( $res ) > 0 ) {
		 		echo "<h1>Profile</h1>";
				foreach( $res as $itm ) {
					$s = Search::highlightString( $itm["title"], QUERY );
					$a = $itm["link"];
					echo "<div class='col card-panel grey lighten-5 z-depth-1 s12 l8 offset-l2'><h5><a href='/profile/$a/'>$s</a></h5></div>";
				}
			}
			$res = Search::forSurveys( QUERY );
			$n += count( $res );
			if( count( $res ) > 0 ) {
				echo "<h1>Umfragen</h1>";
				foreach( $res as $itm ) {
					$s = Search::highlightString( $itm["title"], QUERY );
					$a = $itm["link"];
					echo "<div class='col card-panel grey lighten-5 z-depth-1 s12 l8 offset-l2'><h5><a href='/Surveys/$a/'>$s</a></h5></div>";
				}
			}
			$res = Search::forGroups( QUERY );
			$n += count( $res );
			if( count( $res ) > 0 ) {
				echo "<h1>Gruppen</h1>";
				foreach( $res as $itm ) {
					$s = Search::highlightString( $itm["title"], QUERY );
					$a = $itm["link"];
					echo "<div class='col card-panel grey lighten-5 z-depth-1 s12 l8 offset-l2'><h5><a href='/group/$a/'>$s</a></h5></div>";
				}
			}
			if( $n == 0 ) {
				echo '<h1 class="grey-text text-lighten-1 center"><i style="font-size: 250%; margin-top: 10%;" class="material-icons">search</i></h1><h5 class="grey-text text-lighten-1 center">Nichts Gefunden für: '.QUERY.'</h5>';
			}
		}
		else {
			echo '<h1 class="grey-text text-lighten-1 center"><i style="font-size: 250%; margin-top: 10%;" class="material-icons">search</i></h1><h5 class="grey-text text-lighten-1 center">Suche nach Personen und Umfagen</h5>';
		}
	?>
</div>
