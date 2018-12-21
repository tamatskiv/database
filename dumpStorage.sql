-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema storage
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema storage
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `storage` DEFAULT CHARACTER SET utf8 ;
USE `storage` ;

-- -----------------------------------------------------
-- Table `storage`.`Clients`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `storage`.`Clients` ;

CREATE TABLE IF NOT EXISTS `storage`.`Clients` (
  `idClient` INT NOT NULL,
  `firstName` VARCHAR(45) NOT NULL,
  `lastName` VARCHAR(45) NOT NULL,
  `telephoneNumber` VARCHAR(22) NOT NULL,
  PRIMARY KEY (`idClient`),
  UNIQUE INDEX `telephoneNumber_UNIQUE` (`telephoneNumber` ASC) VISIBLE,
  UNIQUE INDEX `idClient_UNIQUE` (`idClient` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `storage`.`PaymentForm`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `storage`.`PaymentForm` ;

CREATE TABLE IF NOT EXISTS `storage`.`PaymentForm` (
  `idPaymentForm` INT NOT NULL AUTO_INCREMENT,
  `paymentForm` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`idPaymentForm`),
  UNIQUE INDEX `idPaymentForm_UNIQUE` (`idPaymentForm` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `storage`.`ItemsType`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `storage`.`ItemsType` ;

CREATE TABLE IF NOT EXISTS `storage`.`ItemsType` (
  `idItemsType` INT NOT NULL,
  `itemsType` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idItemsType`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `storage`.`Items`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `storage`.`Items` ;

CREATE TABLE IF NOT EXISTS `storage`.`Items` (
  `idItem` INT NOT NULL AUTO_INCREMENT,
  `idItemsType` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `description` VARCHAR(45) NOT NULL,
  `price` FLOAT NOT NULL,
  `unitOfMeasurement` VARCHAR(10) NULL,
  PRIMARY KEY (`idItem`, `idItemsType`),
  UNIQUE INDEX `idItem_UNIQUE` (`idItem` ASC) VISIBLE,
  INDEX `fk_Items_ItemsType1_idx` (`idItemsType` ASC) VISIBLE,
  CONSTRAINT `fk_Items_ItemsType1`
    FOREIGN KEY (`idItemsType`)
    REFERENCES `storage`.`ItemsType` (`idItemsType`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `storage`.`Storages`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `storage`.`Storages` ;

CREATE TABLE IF NOT EXISTS `storage`.`Storages` (
  `idStorage` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `city` VARCHAR(45) NOT NULL,
  `responsiblePerson` INT NOT NULL,
  `active` TINYINT NOT NULL DEFAULT '0',
  `telephoneNumber` VARCHAR(22) NULL,
  PRIMARY KEY (`idStorage`),
  UNIQUE INDEX `idStorage_UNIQUE` (`idStorage` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `storage`.`Issuing`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `storage`.`Issuing` ;

CREATE TABLE IF NOT EXISTS `storage`.`Issuing` (
  `idIssuing` INT NOT NULL AUTO_INCREMENT,
  `idClient` INT NOT NULL,
  `idItem` INT NOT NULL,
  `idStorage` INT NOT NULL,
  `idPaymentForm` INT NOT NULL,
  `date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  `amount` INT NOT NULL,
  `price` FLOAT NOT NULL,
  `total` FLOAT NOT NULL,
  PRIMARY KEY (`idIssuing`, `idClient`, `idItem`, `idStorage`, `idPaymentForm`),
  UNIQUE INDEX `idIssuing_UNIQUE` (`idIssuing` ASC) VISIBLE,
  INDEX `fk_Issuing_Clients_idx` (`idClient` ASC) VISIBLE,
  INDEX `fk_Issuing_Items1_idx` (`idItem` ASC) VISIBLE,
  INDEX `fk_Issuing_Storages1_idx` (`idStorage` ASC) VISIBLE,
  INDEX `fk_Issuing_PaymentForm1_idx` (`idPaymentForm` ASC) VISIBLE,
  CONSTRAINT `fk_Issuing_Clients`
    FOREIGN KEY (`idClient`)
    REFERENCES `storage`.`Clients` (`idClient`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Issuing_Items`
    FOREIGN KEY (`idItem`)
    REFERENCES `storage`.`Items` (`idItem`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Issuing_Storages`
    FOREIGN KEY (`idStorage`)
    REFERENCES `storage`.`Storages` (`idStorage`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Issuing_PaymentForm`
    FOREIGN KEY (`idPaymentForm`)
    REFERENCES `storage`.`PaymentForm` (`idPaymentForm`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `storage`.`Providers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `storage`.`Providers` ;

CREATE TABLE IF NOT EXISTS `storage`.`Providers` (
  `idProvider` INT NOT NULL AUTO_INCREMENT,
  `firstName` VARCHAR(45) NOT NULL,
  `lastName` VARCHAR(45) NOT NULL,
  `address` VARCHAR(45) NULL,
  `company` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idProvider`),
  UNIQUE INDEX `idProvider_UNIQUE` (`idProvider` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `storage`.`Employees`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `storage`.`Employees` ;

CREATE TABLE IF NOT EXISTS `storage`.`Employees` (
  `idEmployee` INT NOT NULL AUTO_INCREMENT,
  `idStorage` INT NOT NULL,
  `firstName` VARCHAR(45) NOT NULL,
  `lastName` VARCHAR(45) NOT NULL,
  `position` VARCHAR(45) NOT NULL,
  `hireDate` DATE NOT NULL,
  PRIMARY KEY (`idEmployee`, `idStorage`),
  UNIQUE INDEX `idEmployee_UNIQUE` (`idEmployee` ASC) VISIBLE,
  INDEX `fk_Employees_Storages1_idx` (`idStorage` ASC) VISIBLE,
  CONSTRAINT `fk_Employees_Storages`
    FOREIGN KEY (`idStorage`)
    REFERENCES `storage`.`Storages` (`idStorage`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `storage`.`Receiving`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `storage`.`Receiving` ;

CREATE TABLE IF NOT EXISTS `storage`.`Receiving` (
  `idReceiving` INT NOT NULL AUTO_INCREMENT,
  `idItem` INT NOT NULL,
  `idProvider` INT NOT NULL,
  `idStorage` INT NOT NULL,
  `idEmployee` INT NOT NULL,
  `date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  `amount` INT NOT NULL,
  `price` FLOAT NOT NULL,
  `total` FLOAT NOT NULL,
  PRIMARY KEY (`idReceiving`, `idItem`, `idProvider`, `idStorage`, `idEmployee`),
  INDEX `fk_Receiving_Items1_idx` (`idItem` ASC) VISIBLE,
  INDEX `fk_Receiving_Providers1_idx` (`idProvider` ASC) VISIBLE,
  INDEX `fk_Receiving_Storages1_idx` (`idStorage` ASC) VISIBLE,
  INDEX `fk_Receiving_Employees_idx` (`idEmployee` ASC) VISIBLE,
  CONSTRAINT `fk_Receiving_Employees`
    FOREIGN KEY (`idEmployee`)
    REFERENCES `storage`.`Employees` (`idEmployee`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Receiving_Items`
    FOREIGN KEY (`idItem`)
    REFERENCES `storage`.`Items` (`idItem`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Receiving_Providers`
    FOREIGN KEY (`idProvider`)
    REFERENCES `storage`.`Providers` (`idProvider`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Receiving_Storages`
    FOREIGN KEY (`idStorage`)
    REFERENCES `storage`.`Storages` (`idStorage`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `storage`.`Clients`
-- -----------------------------------------------------
START TRANSACTION;
USE `storage`;
INSERT INTO `storage`.`Clients` (`idClient`, `firstName`, `lastName`, `telephoneNumber`) VALUES (1, 'Bohdan', 'Melnyk', '0952365125');
INSERT INTO `storage`.`Clients` (`idClient`, `firstName`, `lastName`, `telephoneNumber`) VALUES (2, 'Yuliia', 'Fenii', '0968524679');
INSERT INTO `storage`.`Clients` (`idClient`, `firstName`, `lastName`, `telephoneNumber`) VALUES (3, 'Ihor', 'Lay', '0501257485');
INSERT INTO `storage`.`Clients` (`idClient`, `firstName`, `lastName`, `telephoneNumber`) VALUES (4, 'Vasyl', 'Korostil', '0968326490');
INSERT INTO `storage`.`Clients` (`idClient`, `firstName`, `lastName`, `telephoneNumber`) VALUES (5, 'Yurii', 'Kim', '0956324789');

COMMIT;


-- -----------------------------------------------------
-- Data for table `storage`.`PaymentForm`
-- -----------------------------------------------------
START TRANSACTION;
USE `storage`;
INSERT INTO `storage`.`PaymentForm` (`idPaymentForm`, `paymentForm`) VALUES (1, 'Cash');
INSERT INTO `storage`.`PaymentForm` (`idPaymentForm`, `paymentForm`) VALUES (2, 'Card');
INSERT INTO `storage`.`PaymentForm` (`idPaymentForm`, `paymentForm`) VALUES (3, 'Credit');

COMMIT;


-- -----------------------------------------------------
-- Data for table `storage`.`ItemsType`
-- -----------------------------------------------------
START TRANSACTION;
USE `storage`;
INSERT INTO `storage`.`ItemsType` (`idItemsType`, `itemsType`) VALUES (47, 'Shoes');
INSERT INTO `storage`.`ItemsType` (`idItemsType`, `itemsType`) VALUES (48, 'Clothes');
INSERT INTO `storage`.`ItemsType` (`idItemsType`, `itemsType`) VALUES (49, 'Accessories');
INSERT INTO `storage`.`ItemsType` (`idItemsType`, `itemsType`) VALUES (50, 'Hats');
INSERT INTO `storage`.`ItemsType` (`idItemsType`, `itemsType`) VALUES (51, 'Underwear');

COMMIT;


-- -----------------------------------------------------
-- Data for table `storage`.`Items`
-- -----------------------------------------------------
START TRANSACTION;
USE `storage`;
INSERT INTO `storage`.`Items` (`idItem`, `idItemsType`, `name`, `description`, `price`, `unitOfMeasurement`) VALUES (1, 47, 'Native shoes', 'blue', 1025.98, 'pc');
INSERT INTO `storage`.`Items` (`idItem`, `idItemsType`, `name`, `description`, `price`, `unitOfMeasurement`) VALUES (2, 47, 'Native shoes', 'black', 1025.98, 'pc');
INSERT INTO `storage`.`Items` (`idItem`, `idItemsType`, `name`, `description`, `price`, `unitOfMeasurement`) VALUES (3, 48, 'V-neck', 'white', 340.00, 'pc');
INSERT INTO `storage`.`Items` (`idItem`, `idItemsType`, `name`, `description`, `price`, `unitOfMeasurement`) VALUES (4, 50, 'Mademoiselle', 'red', 163.45, 'pc');
INSERT INTO `storage`.`Items` (`idItem`, `idItemsType`, `name`, `description`, `price`, `unitOfMeasurement`) VALUES (5, 48, 'A-neck', 'black', 321.00, 'pc');
INSERT INTO `storage`.`Items` (`idItem`, `idItemsType`, `name`, `description`, `price`, `unitOfMeasurement`) VALUES (6, 50, 'Sir', 'black', 79.90, 'pc');
INSERT INTO `storage`.`Items` (`idItem`, `idItemsType`, `name`, `description`, `price`, `unitOfMeasurement`) VALUES (7, 49, 'Jewerly', 'gold', 461.52, 'pc');
INSERT INTO `storage`.`Items` (`idItem`, `idItemsType`, `name`, `description`, `price`, `unitOfMeasurement`) VALUES (8, 49, 'Bracelet', 'gold', 589.90, 'pc');
INSERT INTO `storage`.`Items` (`idItem`, `idItemsType`, `name`, `description`, `price`, `unitOfMeasurement`) VALUES (9, 49, 'Ring', 'silver', 147.00, 'pc');
INSERT INTO `storage`.`Items` (`idItem`, `idItemsType`, `name`, `description`, `price`, `unitOfMeasurement`) VALUES (10, 48, 'T-shirt', 'blue', 194.00, 'pc');

COMMIT;


-- -----------------------------------------------------
-- Data for table `storage`.`Storages`
-- -----------------------------------------------------
START TRANSACTION;
USE `storage`;
INSERT INTO `storage`.`Storages` (`idStorage`, `name`, `city`, `responsiblePerson`, `active`, `telephoneNumber`) VALUES (1, 'Billionaire', 'Lviv', 101, 1, '0985217845');
INSERT INTO `storage`.`Storages` (`idStorage`, `name`, `city`, `responsiblePerson`, `active`, `telephoneNumber`) VALUES (2, 'Millionaire', 'Lviv', 106, 1, '0986325471');

COMMIT;


-- -----------------------------------------------------
-- Data for table `storage`.`Issuing`
-- -----------------------------------------------------
START TRANSACTION;
USE `storage`;
INSERT INTO `storage`.`Issuing` (`idIssuing`, `idClient`, `idItem`, `idStorage`, `idPaymentForm`, `date`, `amount`, `price`, `total`) VALUES (12045, 2, 1, 1, 2, '2018-09-05', 15, 1025.98, 15389.7);
INSERT INTO `storage`.`Issuing` (`idIssuing`, `idClient`, `idItem`, `idStorage`, `idPaymentForm`, `date`, `amount`, `price`, `total`) VALUES (12046, 1, 6, 1, 2, '2018-09-06', 42, 79.90, 3355.8);
INSERT INTO `storage`.`Issuing` (`idIssuing`, `idClient`, `idItem`, `idStorage`, `idPaymentForm`, `date`, `amount`, `price`, `total`) VALUES (12047, 3, 9, 2, 1, '2018-09-10', 35, 147.00, 5145);
INSERT INTO `storage`.`Issuing` (`idIssuing`, `idClient`, `idItem`, `idStorage`, `idPaymentForm`, `date`, `amount`, `price`, `total`) VALUES (12048, 3, 8, 2, 1, '2018-09-10', 20, 589.90, 11798);
INSERT INTO `storage`.`Issuing` (`idIssuing`, `idClient`, `idItem`, `idStorage`, `idPaymentForm`, `date`, `amount`, `price`, `total`) VALUES (12049, 5, 10, 1, 2, '2018-09-15', 80, 194.00, 15520);
INSERT INTO `storage`.`Issuing` (`idIssuing`, `idClient`, `idItem`, `idStorage`, `idPaymentForm`, `date`, `amount`, `price`, `total`) VALUES (12050, 5, 3, 1, 2, '2018-09-15', 45, 340.00, 15300);
INSERT INTO `storage`.`Issuing` (`idIssuing`, `idClient`, `idItem`, `idStorage`, `idPaymentForm`, `date`, `amount`, `price`, `total`) VALUES (12051, 5, 5, 2, 2, '2019-09-15', 45, 321.00, 14445);

COMMIT;


-- -----------------------------------------------------
-- Data for table `storage`.`Providers`
-- -----------------------------------------------------
START TRANSACTION;
USE `storage`;
INSERT INTO `storage`.`Providers` (`idProvider`, `firstName`, `lastName`, `address`, `company`) VALUES (25, 'Myroslav', 'Kost', NULL, 'h&m');
INSERT INTO `storage`.`Providers` (`idProvider`, `firstName`, `lastName`, `address`, `company`) VALUES (26, 'Daryna', 'Kostet', NULL, 'forever21');
INSERT INTO `storage`.`Providers` (`idProvider`, `firstName`, `lastName`, `address`, `company`) VALUES (27, 'Olexandr', 'Breusov', NULL, 'zara');
INSERT INTO `storage`.`Providers` (`idProvider`, `firstName`, `lastName`, `address`, `company`) VALUES (28, 'Artem', 'Bilous', NULL, 'stradivarius');

COMMIT;


-- -----------------------------------------------------
-- Data for table `storage`.`Employees`
-- -----------------------------------------------------
START TRANSACTION;
USE `storage`;
INSERT INTO `storage`.`Employees` (`idEmployee`, `idStorage`, `firstName`, `lastName`, `position`, `hireDate`) VALUES (101, 1, 'Roman', 'Myr', 'Director', '2014-03-25');
INSERT INTO `storage`.`Employees` (`idEmployee`, `idStorage`, `firstName`, `lastName`, `position`, `hireDate`) VALUES (102, 1, 'Lesia', 'Struk', 'Manager', '2015-02-28');
INSERT INTO `storage`.`Employees` (`idEmployee`, `idStorage`, `firstName`, `lastName`, `position`, `hireDate`) VALUES (103, 1, 'Viktoriia', 'Zarichna', 'Accountant', '2014-04-05');
INSERT INTO `storage`.`Employees` (`idEmployee`, `idStorage`, `firstName`, `lastName`, `position`, `hireDate`) VALUES (104, 1, 'Serhii', 'Kyryl', 'Loader', '2015-07-26');
INSERT INTO `storage`.`Employees` (`idEmployee`, `idStorage`, `firstName`, `lastName`, `position`, `hireDate`) VALUES (105, 2, 'Andrii', 'Oleks', 'Loader', '2015-07-26');
INSERT INTO `storage`.`Employees` (`idEmployee`, `idStorage`, `firstName`, `lastName`, `position`, `hireDate`) VALUES (106, 2, 'Roman', 'Sand', 'Director', '2015-05-05');
INSERT INTO `storage`.`Employees` (`idEmployee`, `idStorage`, `firstName`, `lastName`, `position`, `hireDate`) VALUES (107, 2, 'Mykola', 'Kushnir', 'Manager', '2015-08-01');

COMMIT;


-- -----------------------------------------------------
-- Data for table `storage`.`Receiving`
-- -----------------------------------------------------
START TRANSACTION;
USE `storage`;
INSERT INTO `storage`.`Receiving` (`idReceiving`, `idItem`, `idProvider`, `idStorage`, `idEmployee`, `date`, `amount`, `price`, `total`) VALUES (101, 1, 26, 1, 104, '2018-08-01', 150, 1025.98, 153897);
INSERT INTO `storage`.`Receiving` (`idReceiving`, `idItem`, `idProvider`, `idStorage`, `idEmployee`, `date`, `amount`, `price`, `total`) VALUES (101, 2, 26, 1, 104, '2018-08-01', 150, 1025.98, 153897);
INSERT INTO `storage`.`Receiving` (`idReceiving`, `idItem`, `idProvider`, `idStorage`, `idEmployee`, `date`, `amount`, `price`, `total`) VALUES (102, 3, 25, 1, 104, '2018-08-05', 200, 340.00, 68000);
INSERT INTO `storage`.`Receiving` (`idReceiving`, `idItem`, `idProvider`, `idStorage`, `idEmployee`, `date`, `amount`, `price`, `total`) VALUES (102, 5, 25, 1, 104, '2018-08-05', 200, 321.00, 64200);
INSERT INTO `storage`.`Receiving` (`idReceiving`, `idItem`, `idProvider`, `idStorage`, `idEmployee`, `date`, `amount`, `price`, `total`) VALUES (102, 10, 25, 1, 104, '2018-08-05', 200, 194.00, 38800);
INSERT INTO `storage`.`Receiving` (`idReceiving`, `idItem`, `idProvider`, `idStorage`, `idEmployee`, `date`, `amount`, `price`, `total`) VALUES (103, 4, 28, 2, 105, '2018-08-10', 130, 163.45, 21248.50);
INSERT INTO `storage`.`Receiving` (`idReceiving`, `idItem`, `idProvider`, `idStorage`, `idEmployee`, `date`, `amount`, `price`, `total`) VALUES (103, 6, 28, 2, 105, '2018-08-10', 130, 79.90, 10387);
INSERT INTO `storage`.`Receiving` (`idReceiving`, `idItem`, `idProvider`, `idStorage`, `idEmployee`, `date`, `amount`, `price`, `total`) VALUES (104, 7, 27, 2, 105, '2018-08-10', 80, 461.52, 36921.60);
INSERT INTO `storage`.`Receiving` (`idReceiving`, `idItem`, `idProvider`, `idStorage`, `idEmployee`, `date`, `amount`, `price`, `total`) VALUES (104, 8, 27, 2, 105, '2018-08-10', 80, 589.90, 47192);
INSERT INTO `storage`.`Receiving` (`idReceiving`, `idItem`, `idProvider`, `idStorage`, `idEmployee`, `date`, `amount`, `price`, `total`) VALUES (105, 9, 27, 2, 105, '2018-08-11', 160, 147.00, 23520);

COMMIT;

