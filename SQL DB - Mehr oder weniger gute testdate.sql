SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

CREATE DATABASE IF NOT EXISTS `yearbook` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `yearbook`;

DROP TABLE IF EXISTS `group_meta`;
CREATE TABLE IF NOT EXISTS `group_meta` (
  `group_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` tinytext NOT NULL,
  `description` text NOT NULL,
  PRIMARY KEY (`group_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COMMENT='latin1_swedish_ci' AUTO_INCREMENT=2 ;

INSERT INTO `group_meta` (`group_id`, `name`, `description`) VALUES
(1, 'roots', 'The gods');

DROP TABLE IF EXISTS `group_participants`;
CREATE TABLE IF NOT EXISTS `group_participants` (
  `group_participants_id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `user_id` text NOT NULL,
  `mod` tinyint(1) NOT NULL,
  PRIMARY KEY (`group_participants_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COMMENT='latin1_swedish_ci' AUTO_INCREMENT=8 ;

INSERT INTO `group_participants` (`group_participants_id`, `group_id`, `user_id`, `mod`) VALUES
(1, 1, 'LukaNagel99', 1),
(2, 1, 'LukaNagel99', 0),
(3, 1, 'LukaNagel99', 0),
(4, 1, 'LukaNagel99', 0),
(5, 1, 'LukaNagel99', 0),
(6, 1, 'LukaNagel99', 0),
(7, 1, 'LukaNagel99', 0);

DROP TABLE IF EXISTS `images_linking`;
CREATE TABLE IF NOT EXISTS `images_linking` (
  `images_linking_id` int(11) NOT NULL AUTO_INCREMENT,
  `image_id` int(11) NOT NULL,
  `gallery_id` int(11) NOT NULL,
  PRIMARY KEY (`images_linking_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='latin1_swedish_ci' AUTO_INCREMENT=1 ;

DROP TABLE IF EXISTS `images_path`;
CREATE TABLE IF NOT EXISTS `images_path` (
  `image_id` int(11) NOT NULL AUTO_INCREMENT,
  `path` text NOT NULL,
  PRIMARY KEY (`image_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='latin1_swedish_ci' AUTO_INCREMENT=1 ;

DROP TABLE IF EXISTS `image_galleries`;
CREATE TABLE IF NOT EXISTS `image_galleries` (
  `gallery_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` text NOT NULL,
  PRIMARY KEY (`gallery_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='latin1_swedish_ci' AUTO_INCREMENT=1 ;

DROP TABLE IF EXISTS `log`;
CREATE TABLE IF NOT EXISTS `log` (
  `log_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` text NOT NULL,
  `content` text NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`log_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COMMENT='latin1_swedish_ci' AUTO_INCREMENT=13 ;

INSERT INTO `log` (`log_id`, `name`, `content`, `date`) VALUES
(1, 'Survey', 'LukaNagel99 added a Survey', '2016-11-19 16:05:01'),
(2, 'Survey', 'LukaNagel99 edited Survey 4', '2016-11-19 16:05:17'),
(3, 'Profile', 'LukaNagel99 changed her/his profile', '2016-11-19 18:42:27'),
(4, 'Profile', 'LukaNagel99 changed her/his profile', '2016-11-19 18:53:11'),
(5, 'Profile', 'LukaNagel99 changed her/his profile', '2016-11-19 19:02:49'),
(6, 'Survey', 'LukaNagel99 edited Survey 2', '2016-11-19 20:55:46'),
(7, 'Survey', 'LukaNagel99 added a Survey', '2016-11-19 20:58:24'),
(8, 'Survey', ' deleted Survey 5', '2016-11-19 20:58:28'),
(9, 'Profile', 'LukaNagel99 changed his/her profile', '2016-11-19 21:09:33'),
(10, 'Profile', 'LukaNagel99 changed her/his profile', '2016-11-19 21:09:43'),
(11, 'Survey', 'LukaNagel99 edited Survey 2', '2016-11-19 22:24:31'),
(12, 'Survey', 'LukaNagel99 edited Survey 2', '2016-11-19 22:25:15');

DROP TABLE IF EXISTS `login_admin`;
CREATE TABLE IF NOT EXISTS `login_admin` (
  `uselesscol` int(11) NOT NULL AUTO_INCREMENT,
  `login_admin_id` text NOT NULL,
  PRIMARY KEY (`uselesscol`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COMMENT='latin1_swedish_ci' AUTO_INCREMENT=2 ;

INSERT INTO `login_admin` (`uselesscol`, `login_admin_id`) VALUES
(1, 'LukaNagel99');

DROP TABLE IF EXISTS `login_info`;
CREATE TABLE IF NOT EXISTS `login_info` (
  `id` text NOT NULL,
  `password` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='latin1_swedish_ci';

INSERT INTO `login_info` (`id`, `password`) VALUES
('LukaNagel99', '16845dc3a7c000f3b9009e5fc2b92bea');

DROP TABLE IF EXISTS `login_tokens`;
CREATE TABLE IF NOT EXISTS `login_tokens` (
  `user_id` text NOT NULL,
  `token` text NOT NULL,
  `expires` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='latin1_swedish_ci';

INSERT INTO `login_tokens` (`user_id`, `token`, `expires`) VALUES
('LukaNagel99', '0135c1be94c5fb0facd1c18a5ce36c69', '2016-11-19 23:26:20');

DROP TABLE IF EXISTS `profiles`;
CREATE TABLE IF NOT EXISTS `profiles` (
  `user_id` text NOT NULL,
  `FName` text NOT NULL,
  `LName` text NOT NULL,
  `avatar` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='latin1_swedish_ci';

INSERT INTO `profiles` (`user_id`, `FName`, `LName`, `avatar`) VALUES
('LukaNagel99', 'Lukas', 'Nagel', 0);

DROP TABLE IF EXISTS `profile_meta_fields`;
CREATE TABLE IF NOT EXISTS `profile_meta_fields` (
  `field_id` int(11) NOT NULL AUTO_INCREMENT,
  `field_title` text,
  `field_type` int(11) DEFAULT NULL,
  `field_opt` text,
  `field_order` int(11) DEFAULT NULL,
  PRIMARY KEY (`field_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COMMENT='latin1_swedish_ci' AUTO_INCREMENT=12 ;

INSERT INTO `profile_meta_fields` (`field_id`, `field_title`, `field_type`, `field_opt`, `field_order`) VALUES
(1, 'Spitzname', 1, '', 0),
(2, 'Geburtstag', 1, '', 1),
(3, 'LK''s', 1, '', 2),
(4, 'Lieblingsfach', 1, '', 3),
(5, 'Lieblingslehrer', 1, '', 4),
(6, 'Zukunftstr&auml;ume', 1, '', 5),
(7, 'Lieblingsflachwitz', 1, '', 6),
(8, 'Die Lage meines Spindes war', 2, 'Sehr Gut|Gut|Geht so|Kacke|Welchen meiner drei meinst du?', 7),
(9, 'Ultimativer &uuml;berlebenstipp', 1, '', 8),
(10, 'Worte zum abschied', 4, '', 9),
(11, 'Welche Abscnitte waren am besten?', 3, 'Prim|Sek I|Sek II', 10);

DROP TABLE IF EXISTS `profile_user_fields`;
CREATE TABLE IF NOT EXISTS `profile_user_fields` (
  `uf_id` int(11) NOT NULL AUTO_INCREMENT,
  `meta_field_id` int(11) DEFAULT NULL,
  `user_id` text,
  `value` text,
  PRIMARY KEY (`uf_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COMMENT='latin1_swedish_ci' AUTO_INCREMENT=12 ;


DROP TABLE IF EXISTS `survey_meta`;
CREATE TABLE IF NOT EXISTS `survey_meta` (
  `survey_meta_id` int(11) NOT NULL AUTO_INCREMENT,
  `survey_title` text NOT NULL,
  `survey_description` text NOT NULL,
  `survey_visible` smallint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`survey_meta_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COMMENT='latin1_swedish_ci' AUTO_INCREMENT=3 ;

INSERT INTO `survey_meta` (`survey_meta_id`, `survey_title`, `survey_description`, `survey_visible`) VALUES
(2, 'Abschluss Mottos', 'VorschlÃ¤ge einfach per Whatsapp', 1);

DROP TABLE IF EXISTS `survey_questions`;
CREATE TABLE IF NOT EXISTS `survey_questions` (
  `survey_id` int(11) NOT NULL,
  `question_id` int(11) NOT NULL AUTO_INCREMENT,
  `question_title` text NOT NULL,
  PRIMARY KEY (`question_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COMMENT='latin1_swedish_ci' AUTO_INCREMENT=5 ;

INSERT INTO `survey_questions` (`survey_id`, `question_id`, `question_title`) VALUES
(2, 1, 'Den semi lustigen und unkreativen Spruch von Julian'),
(2, 2, 'AbiPur, 13 Jahre Stoff und trotzdem nich high'),
(2, 3, 'Sayonara AbiGos'),
(2, 4, '( Hier kÃ¶nnnte ihre Werbung stehen )');

DROP TABLE IF EXISTS `survey_votes`;
CREATE TABLE IF NOT EXISTS `survey_votes` (
  `vote_id` int(11) NOT NULL AUTO_INCREMENT,
  `vote_value` int(11) NOT NULL,
  `vote_user` text NOT NULL,
  `vote_question` int(11) NOT NULL,
  PRIMARY KEY (`vote_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COMMENT='latin1_swedish_ci' AUTO_INCREMENT=9 ;

INSERT INTO `survey_votes` (`vote_id`, `vote_value`, `vote_user`, `vote_question`) VALUES
(1, 0, 'INITVOTE', 1),
(2, 0, 'INITVOTE', 2),
(3, 0, 'INITVOTE', 3),
(4, 0, 'INITVOTE', 4),
(5, -1, 'LukaNagel99', 1),
(6, 1, 'LukaNagel99', 4),
(7, 1, 'LukaNagel99', 3),
(8, 1, 'LukaNagel99', 2);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
