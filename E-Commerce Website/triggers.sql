CREATE TABLE IF NOT EXISTS ACCOUNT_LOG (
    logId INTEGER PRIMARY KEY AUTOINCREMENT,
    userId INT,
    logDateTime DATETIME,
    logMessage TEXT
);
 CREATE TRIGGER after_account_insert
AFTER INSERT ON ACCOUNT
BEGIN
    INSERT INTO ACCOUNT_LOG (userId, logDateTime, logMessage)
    VALUES (NEW.userId, datetime('now'), 'New account created');
END;
CREATE TRIGGER update_avg_point_after_review
AFTER INSERT ON REVIEW
BEGIN
    UPDATE PRODUCT
    SET avgPoint = (
        SELECT AVG(likeNo - dislikeNo)
        FROM REVIEW
        WHERE supplierId = NEW.supplierId
    )
    WHERE productId = (
        SELECT productId
        FROM SUPPLIES_PRODUCT
        WHERE userId = NEW.supplierId
    );
END;
CREATE TRIGGER update_avg_point_after_review
AFTER INSERT ON REVIEW
BEGIN
    UPDATE PRODUCT
    SET avgPoint = (
        SELECT AVG(likeNo - dislikeNo)
        FROM REVIEW
        WHERE supplierId = NEW.supplierId
    )
    WHERE productId = (
        SELECT productId
        FROM SUPPLIES_PRODUCT
        WHERE userId = NEW.supplierId
    );
END;