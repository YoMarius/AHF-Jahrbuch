 <?php require_once $_SERVER["DOCUMENT_ROOT"]."/Core/index.php";

    if ($_SERVER['REQUEST_METHOD'] == 'POST')
    {
      if(isset($_FILES['profil'])){
        $statement = Login::checkUser()["user_id"];
        $upload_type = 'profil';
      }else if(isset($_FILES['group'])){
        $statement = $_POST['group'];
        $upload_type = 'group';
      }else if(isset($_FILES['profilkind'])){
        $statement = Login::checkUser()["user_id"];
        $upload_type = 'profilkind';
      }
      if (!file_exists('../media/img/'.$statement)) {
        mkdir('../media/img/'.$statement, 0777, true);
      echo 'pfad erstellt';
      }
      $max_size = 6500*6500;
      $extensions = array('jpeg', 'jpg', 'png', 'gif');
      $dir = '../media/img/'.$statement.'/';
      $count = 0;
        // loop all files
        foreach ( $_FILES[$upload_type]['name'] as $i => $name )

        {

        // if file not uploaded then skip it
        if ( !is_uploaded_file($_FILES[$upload_type]['tmp_name'][$i]) )
          continue;

          // skip large files
        if ( $_FILES[  $upload_type]['size'][$i] >= $max_size )
          continue;

        // skip unprotected files
        if( !in_array(pathinfo($name, PATHINFO_EXTENSION), $extensions) )
          continue;


          if(file_exists($dir."profilbild.jpg") && $upload_type == 'profil') unlink($dir."profilbild.jpg");

          switch (pathinfo($name, PATHINFO_EXTENSION)) {
              case 'jpg':
              case 'jpeg':
                 $image = imagecreatefromjpeg($_FILES[$upload_type]['tmp_name'][$i]);
              break;
              case 'gif':
                 $image = imagecreatefromgif($_FILES[$upload_type]['tmp_name'][$i]);
              break;
              case 'png':
                 $image = imagecreatefrompng($_FILES[$upload_type]['tmp_name'][$i]);
              break;
          }
          if($upload_type == 'profil'){
          $newone = $dir."profilbild".".jpg";
        }else if($upload_type == 'profilkind'){
            $newone = $dir."kinderbild".".jpg";
          }else{
            $newone = $dir.time().Login::checkUser()["user_id"].".jpg";
          }

          if( imagejpeg($image, $newone,100) )

            $count;
      }

      echo $count." Bild(er) erfolgreich hochgeladen!";

    }
 ?>
