-- MySQL Script generated by MySQL Workbench
-- czw, 10 gru 2020, 16:08:01
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema park_project_database
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema park_project_database
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `park_project_database` ;
-- -----------------------------------------------------
-- Schema park_database
-- -----------------------------------------------------
USE `park_project_database` ;

-- -----------------------------------------------------
-- Table `park_project_database`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `park_project_database`.`user` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(45) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  `account_balance` DECIMAL NOT NULL,
  `name` VARCHAR(45) NULL,
  `surname` VARCHAR(45) NULL,
  `phone_number` INT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `park_project_database`.`parking`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `park_project_database`.`parking` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `country` VARCHAR(45) NOT NULL,
  `zip_code` VARCHAR(45) NOT NULL,
  `city` VARCHAR(45) NOT NULL,
  `street` VARCHAR(45) NOT NULL,
  `street_number` VARCHAR(45) NOT NULL,
  `price_per_hour` INT NOT NULL,
  `admin_acceptance` TINYINT(1) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `park_project_database`.`spot`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `park_project_database`.`spot` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `parking_id` INT NOT NULL,
  `number` INT NOT NULL,
  `size` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`, `user_id`, `parking_id`),
  INDEX `fk_spot_user_idx` (`user_id` ASC) VISIBLE,
  INDEX `fk_spot_parking1_idx` (`parking_id` ASC) VISIBLE,
  CONSTRAINT `fk_spot_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `park_project_database`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_spot_parking1`
    FOREIGN KEY (`parking_id`)
    REFERENCES `park_project_database`.`parking` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `park_project_database`.`user_parking`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `park_project_database`.`user_parking` (
  `user_id` INT NOT NULL,
  `parking_id` INT NOT NULL,
  PRIMARY KEY (`user_id`, `parking_id`),
  INDEX `fk_user_has_parking_parking1_idx` (`parking_id` ASC) VISIBLE,
  INDEX `fk_user_has_parking_user1_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fk_user_has_parking_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `park_project_database`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_has_parking_parking1`
    FOREIGN KEY (`parking_id`)
    REFERENCES `park_project_database`.`parking` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `park_project_database`.`car`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `park_project_database`.`car` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `number_plate` VARCHAR(45) NOT NULL,
  `color` VARCHAR(45) NULL,
  `brand` VARCHAR(45) NULL,
  `model` VARCHAR(45) NULL,
  `size` VARCHAR(45) NOT NULL,
  `spot_id` INT NULL,
  PRIMARY KEY (`id`, `user_id`),
  INDEX `fk_car_user1_idx` (`user_id` ASC) VISIBLE,
  INDEX `fk_car_spot1_idx` (`spot_id` ASC) VISIBLE,
  UNIQUE INDEX `spot_id_UNIQUE` (`spot_id` ASC) VISIBLE,
  CONSTRAINT `fk_car_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `park_project_database`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_car_spot1`
    FOREIGN KEY (`spot_id`)
    REFERENCES `park_project_database`.`spot` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `park_project_database`.`offer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `park_project_database`.`offer` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `spot_id` INT NOT NULL,
  `start_date_time` DATETIME NOT NULL,
  `end_date_time` DATETIME NOT NULL,
  PRIMARY KEY (`id`, `spot_id`),
  INDEX `fk_offer_spot1_idx` (`spot_id` ASC) VISIBLE,
  CONSTRAINT `fk_offer_spot1`
    FOREIGN KEY (`spot_id`)
    REFERENCES `park_project_database`.`spot` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `park_project_database`.`request`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `park_project_database`.`request` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `car_id` INT NOT NULL,
  `start_date_time` DATETIME NOT NULL,
  `end_date_time` DATETIME NOT NULL,
  PRIMARY KEY (`id`, `car_id`),
  INDEX `fk_request_car1_idx` (`car_id` ASC) VISIBLE,
  CONSTRAINT `fk_request_car1`
    FOREIGN KEY (`car_id`)
    REFERENCES `park_project_database`.`car` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `park_project_database`.`transaction`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `park_project_database`.`transaction` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `spot_id` INT NOT NULL,
  `car_id` INT NOT NULL,
  `start_date_time` DATETIME NOT NULL,
  `end_date_time` DATETIME NULL,
  `amount` INT NULL,
  PRIMARY KEY (`id`, `spot_id`, `car_id`),
  INDEX `fk_transaction_spot1_idx` (`spot_id` ASC) VISIBLE,
  INDEX `fk_transaction_car1_idx` (`car_id` ASC) VISIBLE,
  CONSTRAINT `fk_transaction_spot1`
    FOREIGN KEY (`spot_id`)
    REFERENCES `park_project_database`.`spot` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_transaction_car1`
    FOREIGN KEY (`car_id`)
    REFERENCES `park_project_database`.`car` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
