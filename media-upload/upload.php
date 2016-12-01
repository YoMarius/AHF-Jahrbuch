<?php require_once $_SERVER["DOCUMENT_ROOT"]."/Core/index.php";
	
	echo "<pre>";print_r( $_POST  );echo "</pre>";
	echo "<pre>";print_r( $_FILES );echo "</pre>";
	

?>
<form action="upload.php" method="POST" enctype="multipart/form-data">
	<p>Pictures:
	<input type="file" name="pictures[]" />
	<input type="file" name="pictures[]" />
	<input type="file" name="pictures[]" />
	<input type="submit" value="Send" />
	</p>
</form>
