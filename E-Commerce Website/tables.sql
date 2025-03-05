-- ACCOUNT Table
CREATE TABLE ACCOUNT (
    userId INT PRIMARY KEY,
    firstName VARCHAR(50),
    lastName VARCHAR(50),
    phoneNo VARCHAR(15),
    email VARCHAR(100) UNIQUE,
    password VARCHAR(255),
    CHECK (email LIKE '%_@_%._%')
);

-- CUSTOMER Table
CREATE TABLE CUSTOMER (
    userId INT PRIMARY KEY,
    followedNo INT,
    followersNo INT,
    birthDate DATE,
    IBAN VARCHAR(34) UNIQUE,
    FOREIGN KEY (userId) REFERENCES ACCOUNT(userId)
);

-- PRIVILEGE_CUSTOMER Table
CREATE TABLE PRIVILEGE_CUSTOMER (
    userId INT PRIMARY KEY,
    startDate DATE,
    endDate DATE,
    type VARCHAR(50),
    FOREIGN KEY (userId) REFERENCES CUSTOMER(userId),
    CHECK (endDate >= startDate)
);

-- SUPPLIER Table
CREATE TABLE SUPPLIER (
    userId INT PRIMARY KEY,
    mersisNo VARCHAR(20) UNIQUE,
    taxIdNo VARCHAR(20) UNIQUE,
    address TEXT,
    point INT,
    followers INT,
    productCount INT,
    avgShippingTime TIME,
    contactInfo TEXT,
    FOREIGN KEY (userId) REFERENCES ACCOUNT(userId)
);

CREATE TABLE ADMIN (
    userId INT PRIMARY KEY,
    duty VARCHAR(50),
    FOREIGN KEY (userId) REFERENCES ACCOUNT(userId)
);


-- FAVORITE_LIST Table
CREATE TABLE FAVORITE_LIST (
    favoriteListId INT PRIMARY KEY,
    quantity INT,
    userId INT,
    FOREIGN KEY (userId) REFERENCES CUSTOMER(userId)
);

-- ADDED_TO_FAVORITE Table
CREATE TABLE ADDED_TO_FAVORITE (
    productId INT,
    favoriteListId INT,
    PRIMARY KEY (productId, favoriteListId),
    FOREIGN KEY (productId) REFERENCES PRODUCT(productId),
    FOREIGN KEY (favoriteListId) REFERENCES FAVORITE_LIST(favoriteListId)
);

-- USER_LIST Table
CREATE TABLE USER_LIST (
    userListId INT PRIMARY KEY,
    name VARCHAR(50),
    privacy BOOLEAN,
    quantity INT,
    userId INT,
    FOREIGN KEY (userId) REFERENCES CUSTOMER(userId)
);

-- ADDED_TO_LIST Table
CREATE TABLE ADDED_TO_LIST (
    productId INT,
    userListId INT,
    PRIMARY KEY (productId, userListId),
    FOREIGN KEY (productId) REFERENCES PRODUCT(productId),
    FOREIGN KEY (userListId) REFERENCES USER_LIST(userListId)
);

-- INVENTORY Table
CREATE TABLE INVENTORY (
    inventoryId INT AUTO_INCREMENT PRIMARY KEY,
    lastUpdateDate DATE,
    stockLevel INT,
    CHECK (stockLevel >= 0)
);

-- TRACKED_BY Table
CREATE TABLE TRACKED_BY (
    inventoryId INT,
    productId INT,
    PRIMARY KEY (inventoryId, productId),
    FOREIGN KEY (inventoryId) REFERENCES INVENTORY(inventoryId),
    FOREIGN KEY (productId) REFERENCES PRODUCT(productId)
);

-- ADDRESS_BOOK Table
CREATE TABLE ADDRESS_BOOK (
    addressId INT PRIMARY KEY,
    userId INT,
    neighbourhood VARCHAR(50),
    city VARCHAR(50),
    district VARCHAR(50),
    billingAddress BOOLEAN,
    shippingAddress BOOLEAN,
    name VARCHAR(50),
    buildingName VARCHAR(50),
    receiverPhoneNo VARCHAR(15),
    receiverFName VARCHAR(50),
    receiverLName VARCHAR(50),
    explanation TEXT,
    FOREIGN KEY (userId) REFERENCES ACCOUNT(userId)
);

-- PRODUCT_PHOTOS Table
CREATE TABLE PRODUCT_PHOTOS (
    productId INT,
    photo TEXT,
    PRIMARY KEY (productId, photo),
    FOREIGN KEY (productId) REFERENCES PRODUCT(productId)
);

-- APPLIES_DISCOUNT Table
CREATE TABLE APPLIES_DISCOUNT (
    userId INT,
    discountId INT,
    PRIMARY KEY (userId, discountId),
    FOREIGN KEY (userId) REFERENCES CUSTOMER(userId),
    FOREIGN KEY (discountId) REFERENCES DISCOUNT(discountId)
);

-- ORDER Table
CREATE TABLE ORDERS (
    paymentId INT,
    orderId INT,
    addressId INT,
    amount DECIMAL(10, 2),
    type VARCHAR(50),
    Odate DATE,
    status VARCHAR(50),
    PRIMARY KEY (paymentId, orderId),
    FOREIGN KEY (paymentId) REFERENCES PAYMENT(paymentId),
    FOREIGN KEY (addressId) REFERENCES ADDRESS_BOOK(addressId)
);


-- ORDER_HISTORY_LIST Table
CREATE TABLE ORDER_HISTORY_LIST (
    paymentId INT,
    orderId INT,
    orderHistoryList TEXT,
    PRIMARY KEY (paymentId, orderId, orderHistoryList),
    FOREIGN KEY (paymentId, orderId) REFERENCES ORDERS(paymentId, orderId)
);

-- ORDER_ITEM Table
CREATE TABLE ORDER_ITEM (
    paymentId INT,
    orderId INT,
    orderDetailId INT,
    returnId INT,
    quantity INT,
    PRIMARY KEY (paymentId, orderId, orderDetailId),
    FOREIGN KEY (paymentId, orderId) REFERENCES ORDERS(paymentId, orderId),
    FOREIGN KEY (returnId) REFERENCES RETURN(returnId)
);

-- CARGO Table
CREATE TABLE CARGO (
    orderId INT,
    paymentId INT,
    cargoTrackNo INT,
    PRIMARY KEY (orderId, paymentId, cargoTrackNo),
    FOREIGN KEY (orderId, paymentId) REFERENCES ORDERS(orderId, paymentId),
    FOREIGN KEY (cargoTrackNo) REFERENCES SHIPPING(cargo_track_no)
);


-- PAYMENT Table
CREATE TABLE PAYMENT (
    paymentId INT PRIMARY KEY,
    totalAmount DECIMAL(10, 2),
    Pdate DATE,
    status VARCHAR(50)
);

-- GIFT_POINT Table
CREATE TABLE GIFT_POINT (
    paymentId INT,
    pointId INT PRIMARY KEY,
    balance DECIMAL(10, 2),
    FOREIGN KEY (paymentId) REFERENCES PAYMENT(paymentId)
);
-- LOAN_PAYMENT Table
CREATE TABLE LOAN_PAYMENT (
    paymentId INT,
    loanId INT PRIMARY KEY,
    bankName VARCHAR(100),
    interestRate DECIMAL(5, 2),
    loanLimit DECIMAL(10, 2),
    FOREIGN KEY (paymentId) REFERENCES PAYMENT(paymentId)
);

-- GIFT_CARD Table
CREATE TABLE GIFT_CARD (
    paymentId INT,
    giftCardId INT PRIMARY KEY,
    balance DECIMAL(10, 2),
    endDate DATE,
    FOREIGN KEY (paymentId) REFERENCES PAYMENT(paymentId)
);

-- CREDIT_CARD Table
CREATE TABLE CREDIT_CARD (
    paymentId INT,
    cardNumber VARCHAR(16) PRIMARY KEY,
    expireDate DATE,
    CVV VARCHAR(4),
    cardHolder VARCHAR(50),
    cardName VARCHAR(50),
    FOREIGN KEY (paymentId) REFERENCES PAYMENT(paymentId)
);

-- NOTIFICATION Table
CREATE TABLE NOTIFICATION (
    adminUserId INT,
    userId INT,
    notificationId INT PRIMARY KEY,
    type VARCHAR(50),
    Ndate DATE,
    Ntext TEXT,
    FOREIGN KEY (userId) REFERENCES ACCOUNT(userId),
    FOREIGN KEY (adminUserId) REFERENCES ADMIN(userId)
);


-- RETURN Table
CREATE TABLE RETURN (
    userId INT,
    returnId INT PRIMARY KEY,
    returnCode VARCHAR(50) UNIQUE,
    requestReason TEXT,
    quantity INT,
    status VARCHAR(50),
    FOREIGN KEY (userId) REFERENCES CUSTOMER(userId)
);

-- PRODUCT Table
CREATE TABLE PRODUCT (
    productId INT PRIMARY KEY,
    categoryId INT,
    features TEXT,
    price DECIMAL(10, 2),
    brand VARCHAR(50),
    guarantee BOOLEAN,
    avgPoint DECIMAL(3, 2),
    stockCode VARCHAR(50),
    name VARCHAR(50),
    refundCond TEXT,
    overseaSale BOOLEAN,
    FOREIGN KEY (categoryId) REFERENCES CATEGORY(categoryId)
);

-- SUPPLIES_PRODUCT Table
CREATE TABLE SUPPLIES_PRODUCT (
    userId INT,
    productId INT,
    PRIMARY KEY (userId, productId),
    FOREIGN KEY (userId) REFERENCES SUPPLIER(userId),
    FOREIGN KEY (productId) REFERENCES PRODUCT(productId)
);
-- BENEFITS Table
CREATE TABLE BENEFITS (
    benefitId INT,
    userId INT,
    benefitType VARCHAR(50),
    description TEXT,
    name VARCHAR(50),
    giftPointEarning DECIMAL(10, 2),
    PRIMARY KEY (benefitId, userId),
    FOREIGN KEY (userId) REFERENCES CUSTOMER(userId)
);

-- DISCOUNT Table
CREATE TABLE DISCOUNT (
    discountId INT PRIMARY KEY,
    discountCode VARCHAR(50) UNIQUE,
    description TEXT,
    minPrice DECIMAL(10, 2),
    isActive BOOLEAN,
    startDate DATE,
    endDate DATE
);

-- STACKABLE_DISCOUNT Table
CREATE TABLE STACKABLE_DISCOUNT (
    discountId INT PRIMARY KEY,
    priority INT,
    isStackable BOOLEAN,
    FOREIGN KEY (discountId) REFERENCES DISCOUNT(discountId)
);

-- PERCENTAGE_DISCOUNT Table
CREATE TABLE PERCENTAGE_DISCOUNT (
    discountId INT PRIMARY KEY,
    percentageRate DECIMAL(5, 2),
    FOREIGN KEY (discountId) REFERENCES DISCOUNT(discountId)
);

-- FIXED_AMOUNT_DISCOUNT Table
CREATE TABLE FIXED_AMOUNT_DISCOUNT (
    discountId INT PRIMARY KEY,
    discountAmount DECIMAL(10, 2),
    currency VARCHAR(10),
    FOREIGN KEY (discountId) REFERENCES DISCOUNT(discountId)
);

-- SHIPPING Table
CREATE TABLE SHIPPING (
    cargo_track_no INT PRIMARY KEY,
    branchphoneNo VARCHAR(15),
    branchAddress TEXT,
    status VARCHAR(50),
    estimatedDeliveryTime DATE,
    userId INT,
    FOREIGN KEY (userId) REFERENCES SUPPLIER(userId)
);

-- PICKUP_SHIPPING Table
CREATE TABLE PICKUP_SHIPPING (
    cargo_track_no INT PRIMARY KEY,
    pickupLocation TEXT,
    workingHours VARCHAR(50),
    userId INT,
    FOREIGN KEY (cargo_track_no) REFERENCES SHIPPING(cargo_track_no),
    FOREIGN KEY (userId) REFERENCES SUPPLIER(userId)
);

-- DELIVERY_SHIPPING Table
CREATE TABLE DELIVERY_SHIPPING (

    cargo_track_no INT PRIMARY KEY,
    userId INT,
    FOREIGN KEY (cargo_track_no) REFERENCES SHIPPING(cargo_track_no),
    FOREIGN KEY (userId) REFERENCES SUPPLIER(userId)
);

-- BASKET Table
CREATE TABLE BASKET (
    userId INT,
    productId INT,
    basketId INT,
    discountId INT,
    shipmentPrice DECIMAL(10, 2),
    shipmentDate DATE,
    totalPrice DECIMAL(10, 2),
    PRIMARY KEY (userId, productId, basketId),
    FOREIGN KEY (discountId) REFERENCES DISCOUNT(discountId),
    FOREIGN KEY (userId) REFERENCES CUSTOMER(userId),
    FOREIGN KEY (productId) REFERENCES PRODUCT(productId)
);

-- ADDS_TO_BASKET Table
CREATE TABLE ADDS_TO_BASKET (
    userId INT,
    discountId INT,
    PRIMARY KEY (userId, discountId),
    FOREIGN KEY (userId) REFERENCES CUSTOMER(userId),
    FOREIGN KEY (discountId) REFERENCES DISCOUNT(discountId)
);

-- QA Table
CREATE TABLE QA (
    questionId INT PRIMARY KEY,
    userId INT,
    supplierId INT,
    like_no INT,
    dislike_no INT,
    responseTime TIME,
    Qdate DATE,
    answerText TEXT,
    questionText TEXT,
    FOREIGN KEY (userId) REFERENCES CUSTOMER(userId),
    FOREIGN KEY (supplierId) REFERENCES SUPPLIER(userId)
);

-- REVIEW Table
CREATE TABLE REVIEW (
    reviewId INT PRIMARY KEY,
    dislikeNo INT,
    Rdate DATE,
    Rtext TEXT,
    likeNo INT,
    userId INT,
    supplierId INT,
    FOREIGN KEY (userId) REFERENCES CUSTOMER(userId),
    FOREIGN KEY (supplierId) REFERENCES SUPPLIER(userId)
);

-- REVIEW_PICTURES Table
CREATE TABLE REVIEW_PICTURES (
    reviewId INT,
    picture TEXT,
    PRIMARY KEY (reviewId, picture),
    FOREIGN KEY (reviewId) REFERENCES REVIEW(reviewId)
);

-- AUDITS_REVIEW Table
CREATE TABLE AUDITS_REVIEW (
    reviewId INT,
    adminUserId INT,
    PRIMARY KEY (reviewId, adminUserId),
    FOREIGN KEY (reviewId) REFERENCES REVIEW(reviewId),
    FOREIGN KEY (adminUserId) REFERENCES ADMIN(userId)
);

-- AUDITS_QA Table
CREATE TABLE AUDITS_QA (
    questionId INT,
    adminUserId INT,
    PRIMARY KEY (questionId, adminUserId),
    FOREIGN KEY (questionId) REFERENCES QA(questionId),
    FOREIGN KEY (adminUserId) REFERENCES ADMIN(userId)
);

-- BASKET_RESULTS_IN_PAYMENT Table
CREATE TABLE BASKET_RESULTS_IN_PAYMENT (
    userId INT,
    productId INT,
    basketId INT,
    paymentId INT,
    PRIMARY KEY (userId, productId, basketId, paymentId),
    FOREIGN KEY (userId, productId, basketId) REFERENCES BASKET(userId, productId, basketId),
    FOREIGN KEY (paymentId) REFERENCES PAYMENT(paymentId)
);
-- CATEGORY Table
CREATE TABLE CATEGORY (
    categoryId INT PRIMARY KEY,
    productQuantity INT,
    name VARCHAR(50),
    superCategoryId INT,
    FOREIGN KEY (superCategoryId) REFERENCES CATEGORY(categoryId)
);

-- DYNAMIC_CATEGORY Table
CREATE TABLE DYNAMIC_CATEGORY (
    categoryId INT PRIMARY KEY,
    startDate DATE,
    endDate DATE,
    FOREIGN KEY (categoryId) REFERENCES CATEGORY(categoryId)
);


SORU-2

-- ACCOUNT Table
INSERT INTO ACCOUNT (userId, firstName, lastName, phoneNo, email, password)
VALUES 
(1, 'John', 'Doe', '1234567890', 'john.doe@example.com', 'password123'),
(2, 'Jane', 'Smith', '0987654321', 'jane.smith@example.com', 'password456'),
(3, 'Supplier', 'One', '1122334455', 'supplier.one@example.com', 'password789'),
(4, 'Admin', 'One', '1122336789', 'admin.one@example.com', 'password157');

-- CATEGORY Table
INSERT INTO CATEGORY (categoryId, productQuantity, name, superCategoryId)
VALUES
(1, 100, 'Electronics', NULL),
(2, 50, 'Clothing', NULL),
(3, 30, 'Smartphones', 1);

-- PAYMENT Table
INSERT INTO PAYMENT (paymentId, totalAmount, Pdate, status)
VALUES
(1, 99.99, '2023-12-01', 'Completed'),
(2, 199.99, '2023-12-02', 'Pending'),
(3, 49.99, '2023-12-03', 'Failed');

INSERT INTO ADMIN (userId, duty)
 VALUES
 (4, 'Super Administrator');

-- CUSTOMER Table
INSERT INTO CUSTOMER (userId, followedNo, followersNo, birthDate, IBAN)
VALUES
(1, 5, 10, '1990-01-01', 'TR330006100519786457841326'),
(2, 8, 20, '1985-06-15', 'TR110006200145631278000451');

-- SUPPLIER Table
INSERT INTO SUPPLIER (userId, mersisNo, taxIdNo, address, point, followers, productCount, avgShippingTime, contactInfo)
VALUES
(3, '123456789012345', '9876543210', '123 Supplier St.', 4, 200, 50, '02:30:00', 'supplier.one@example.com');


-- PRODUCT Table
INSERT INTO PRODUCT (productId, categoryId, features, price, brand, guarantee, avgPoint, stockCode, name, refundCond, overseaSale)
VALUES
(1, 3, '128GB, 6GB RAM', 699.99, 'BrandA', TRUE, 4.5, 'SKU12345', 'Smartphone A', '14 days return', TRUE),
(2, 1, '55-inch 4K UHD', 799.99, 'BrandB', TRUE, 4.8, 'SKU67890', 'Smart TV B', '30 days return', TRUE);

-- SUPPLIES_PRODUCT Table
INSERT INTO SUPPLIES_PRODUCT (userId, productId)
VALUES
(3, 1),
(3, 2);

-- FAVORITE_LIST Table
INSERT INTO FAVORITE_LIST (favoriteListId, quantity, userId)
VALUES
(1, 2, 1),
(2, 1, 2);

-- ADDED_TO_FAVORITE Table
INSERT INTO ADDED_TO_FAVORITE (productId, favoriteListId)
VALUES
(1, 1),
(2, 2);

-- ORDERS Table
INSERT INTO ORDERS (paymentId, orderId, addressId, amount, type, Odate, status)
VALUES
(1, 1, 1, 99.99, 'Online', '2023-12-01', 'Shipped'),
(2, 2, 2, 199.99, 'In-Store', '2023-12-02', 'Processing');

-- BASKET Table
INSERT INTO BASKET (userId, productId, basketId, discountId, shipmentPrice, shipmentDate, totalPrice)
VALUES
(1, 1, 1, NULL, 10.00, '2023-12-01', 709.99),
(2, 2, 2, NULL, 15.00, '2023-12-02', 814.99);

-- QA Table
INSERT INTO QA (questionId, userId, supplierId, like_no, dislike_no, responseTime, Qdate, answerText, questionText)
VALUES
(1, 1, 3, 5, 1, '00:30:00', '2023-12-01', 'Yes, it is compatible.', 'Is this smartphone compatible with 5G?');

-- ADDRESS_BOOK Table
INSERT INTO ADDRESS_BOOK (addressId, userId, neighbourhood, city, district, billingAddress, shippingAddress, name, buildingName, receiverPhoneNo, receiverFName, receiverLName, explanation)
VALUES
(1, 1, 'Downtown', 'New York', 'Manhattan', TRUE, FALSE, 'Home', 'Building A', '1234567890', 'John', 'Doe', 'Deliver to front desk'),
(2, 2, 'Uptown', 'San Francisco', 'Richmond', FALSE, TRUE, 'Office', 'Tower B', '0987654321', 'Jane', 'Smith', 'Leave at reception');

-- PRODUCT_PHOTOS Table
INSERT INTO PRODUCT_PHOTOS (productId, photo)
VALUES
(1, 'https://example.com/photos/smartphone.jpg'),
(2, 'https://example.com/photos/tv.jpg');

-- APPLIES_DISCOUNT Table
INSERT INTO APPLIES_DISCOUNT (userId, discountId)
VALUES
(1, 1),
(2, 2);

-- ORDER_HISTORY_LIST Table
INSERT INTO ORDER_HISTORY_LIST (paymentId, orderId, orderHistoryList)
VALUES
(1, 1, 'Order placed, shipped, delivered'),
(2, 2, 'Order placed, processing');

-- ORDER_ITEM Table
INSERT INTO ORDER_ITEM (paymentId, orderId, orderDetailId, returnId, quantity)
VALUES
(1, 1, 1, NULL, 1),
(2, 2, 2, NULL, 2);

-- CARGO Table
INSERT INTO CARGO (orderId, paymentId, cargoTrackNo)
VALUES
(1, 1, 1001),
(2, 2, 1002);

-- GIFT_POINT Table
INSERT INTO GIFT_POINT (paymentId, pointId, balance)
VALUES
(1, 1, 10.00);

-- CREDIT_CARD Table
INSERT INTO CREDIT_CARD (paymentId, cardNumber, expireDate, CVV, cardHolder, cardName)
VALUES
(2, '5555666677778888', '2025-01-01', '456', 'Jane Smith', 'MasterCard');

-- NOTIFICATION Table
INSERT INTO NOTIFICATION (adminUserId, userId, notificationId, type, Ndate, Ntext)
VALUES
(4, 1, 1, 'Order Update', '2023-12-02', 'Your order has been shipped.'),
(4, 2, 2, 'Discount Offer', '2023-12-03', '20% off on your next purchase!');

-- RETURN Table
INSERT INTO RETURN (userId, returnId, returnCode, requestReason, quantity, status)
VALUES
(1, 1, 'RET123', 'Defective item', 1, 'Pending'),
(2, 2, 'RET456', 'Changed mind', 2, 'Approved');

-- REVIEW Table
INSERT INTO REVIEW (reviewId, dislikeNo, Rdate, Rtext, likeNo, userId, supplierId)
VALUES
(1, 0, '2023-12-01', 'Great product!', 5, 1, 3),
(2, 1, '2023-12-02', 'Not as described.', 2, 2, 3);

-- REVIEW_PICTURES Table
INSERT INTO REVIEW_PICTURES (reviewId, picture)
VALUES
(1, 'https://example.com/reviews/review1.jpg'),
(2, 'https://example.com/reviews/review2.jpg');

-- AUDITS_REVIEW Table
INSERT INTO AUDITS_REVIEW (reviewId, adminUserId)
VALUES
(1, 4),
(2, 4);

-- AUDITS_QA Table
INSERT INTO AUDITS_QA (questionId, adminUserId)
VALUES
(1, 4);

-- BASKET_RESULTS_IN_PAYMENT Table
INSERT INTO BASKET_RESULTS_IN_PAYMENT (userId, productId, basketId, paymentId)
VALUES
(1, 1, 1, 1),
(2, 2, 2, 2);

-- DYNAMIC_CATEGORY Table
INSERT INTO DYNAMIC_CATEGORY (categoryId, startDate, endDate)
VALUES
(1, '2023-12-01', '2023-12-31'),
(2, '2023-12-15', '2024-01-15');


