SELECT 
    P.name AS ProductName,
    COUNT(AF.favoriteListId) AS FavoriteCount,
    AVG(P.avgPoint) AS AverageRating,
    SUM(P.price) AS TotalValueOfFavorites
FROM 
    PRODUCT P
JOIN 
    ADDED_TO_FAVORITE AF ON P.productId = AF.productId
GROUP BY 
    P.productId
ORDER BY 
    FavoriteCount DESC;
-- This query finds popular products by counting how many times each product 
-- has been added to favorite lists. 
-- It also shows the product's average rating and the total value of all its favorites (sum of its price).
-- The results are sorted so that the most favorited products appear first.
SELECT 
    A.firstName || ' ' || A.lastName AS CustomerName,
    P.paymentId,
    P.totalAmount,
    P.Pdate AS PaymentDate,
    P.status AS PaymentStatus
FROM 
    ACCOUNT A
JOIN 
    CUSTOMER C ON A.userId = C.userId
JOIN 
    PAYMENT P ON C.userId = P.paymentId
WHERE 
    P.status IN ('Pending', 'Failed')
ORDER BY 
    P.Pdate DESC;
-- This query retrieves payment details for customers whose payments are either pending or failed.
-- It displays the customer's full name, payment ID, total amount, payment date, and payment status.
-- The results are sorted by payment date in descending order, showing the most recent payments first.
SELECT 
    'Gift Point' AS PaymentMethod, 
    COUNT(*) AS UsageCount
FROM 
    GIFT_POINT
WHERE 
    balance > 0

UNION ALL

SELECT 
    'Credit Card' AS PaymentMethod, 
    COUNT(*) AS UsageCount
FROM 
    CREDIT_CARD

UNION ALL

SELECT 
    'Loan Payment' AS PaymentMethod, 
    COUNT(*) AS UsageCount
FROM 
    LOAN_PAYMENT

UNION ALL

SELECT 
    'Gift Card' AS PaymentMethod, 
    COUNT(*) AS UsageCount
FROM 
    GIFT_CARD
WHERE 
    balance > 0;
-- This query counts the number of active payment methods used, grouping them into four categories:  
-- "Gift Point," "Credit Card," "Loan Payment," and "Gift Card."  
-- It only includes gift points and gift cards with a positive balance.  
-- The results show each payment method along with its usage count.  
    SELECT 
    S.userId AS SupplierID,
    A.firstName || ' ' || A.lastName AS SupplierName,
    COUNT(P.productId) AS TotalProducts,
    AVG(P.price) AS AverageProductPrice,
    AVG(P.avgPoint) AS AverageProductRating
FROM 
    SUPPLIER S
JOIN 
    ACCOUNT A ON S.userId = A.userId
JOIN 
    SUPPLIES_PRODUCT SP ON S.userId = SP.userId
JOIN 
    PRODUCT P ON SP.productId = P.productId
GROUP BY 
    S.userId
ORDER BY 
    AverageProductRating DESC;
-- This query shows supplier statistics, including their ID, name, total products supplied, 
-- average product price, and average rating. Results are sorted by average product rating.
