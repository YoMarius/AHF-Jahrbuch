<?php require_once( "db.php" );
class Upload{
  function showUploadSection($name, $group = ""){
    echo '
    <form id="imguploader" action="/media-upload/upload.php" method="POST" enctype="multipart/form-data">
      <input type="file" name="'.$name.'[]" id="'.$name.'" multiple="multiple"/>
      <input type="text" style="display:none;" name="group" value='.$group.'  />
      <input type="submit" id="senden" name="submit" value="Upload" />
    </form>
    <div id="preview" style="display:none"></div>
';
  }




}
?>
