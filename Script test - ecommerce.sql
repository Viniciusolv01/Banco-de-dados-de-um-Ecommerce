-- criação do bando de dados para um cenário de E-commerce
create database ecommerce;
use ecommerce;


-- criar tabela cliente 
create table cliente(
      idCliente int auto_increment primary key,
	  Fname varchar(10),
      Minit char(3),
      Lname varchar(20),
      CPF char(11) not null,
      Adress varchar(30),
      constraint unique_cpf_cliente unique (CPF)
      );
	desc cliente;
    
-- criar tabela produto

-- size - dimensão do produto
create table product(
      idProduct int auto_increment primary key,
	  Pname varchar(10),
      classification_kids bool default false,
      category enum('Eletrônico','vestimenta','Brinquedos','Alimentos','Móveis') not null,
      Avaliação float default 0,
      Size varchar(10)
);

create table payments(
   idCliente int,
   idPayment int,
   typePayment enum('Boleto','Cartão','Dois cartões'),
   limitAvailable float,
   primary key(idCliente, id_payment),
   CONSTRAINT fk_payment_client FOREIGN KEY (idCliente) REFERENCES cliente(idCliente)
   );

-- criar tabela pedido
create table orders(
   idOrder int auto_increment primary key,
   idOrderClient int,
   orderStatus enum('Cancelado','Confirmado','Em processamento') default 'Em processamento',
   orderDescription varchar(255),
   sendValue float default 10,
   paymentcash boolean default false,
   constraint fk_ordes_client foreign key (idOrderClient) references cliente(idCliente)
);
desc orders;

-- criar tabela estoque
create table productStorage(
    idProdStorage int auto_increment primary key,
    storageLocation varchar(255),
	quantity int default 0
    );
    
-- criar tabela fornecedor
create table supplier(
    idSupplier int auto_increment primary key,
    SocialName varchar(255) not null,
    CNPJ char(15) not null,
    contact char(11) not null,
    constraint unique_supplier unique (CNPJ)
    );
    
-- criar tabela vendedor
    create table seller(
    idSeller int auto_increment primary key,
    SocialName varchar(255) not null,
    AbstName varchar(255),
    CNPJ char(15) not null,
    CPF char(11) not null,
    location varchar (255),
    contact char(11) not null,
    constraint unique_cnpj_seller unique (CNPJ),
    constraint unique_cpf_seller unique (CPF)
    );
    
   
create table productSeller(
    idPseller int,
    idProduct int,
    prodquantity int default 1,
    primary key (idPseller, idProduct),
    constraint fk_product_seller foreign key (idPseller) references seller(idSeller),
    constraint fk_product_product foreign key (idProduct) references product(idProduct)
    );
    
create table productOrder(
    idPOproduct int,
    idPOorder int,
    poQuantity int default 1,
    poStatus enum('Disponível', 'Sem estoque') default 'Disponível',
    primary key (idPOproduct, idPOorder),
    constraint fk_productorder_seller foreign key (idPOproduct) references product(idProduct),
    constraint fk_productorder_product foreign key (idPOorder) references orders (idOrder)
    );
    
    create table storageLocation(
    idLproduct int,
    idLstorage int,
    location varchar (255) not null,
    primary key (idLproduct, idLstorage),
    constraint fk_storage_location_product foreign key (idLproduct) references product(idProduct),
    constraint fk_storage_location_storage foreign key (idLstorage) references productStorage(idProdStorage)
    );
    show tables;
    
    create table productSupplier(
    idPsSupplier int,
    idPsProduct int,
    quantity int not null,
    primary key (idPsSupplier, idPsProduct),
    constraint fk_product_supplier_supplier foreign key (idPsSupplier) references supplier(idSupplier),
    constraint fk_product_supplier_product foreign key (idPsProduct) references product(idProduct)
    );
	
    CREATE TABLE payments (
    idCliente INT,
    idPayment INT,
    typePayment ENUM('Boleto','Cartão','Dois cartões'),
    limitAvailable FLOAT,
    PRIMARY KEY (idCliente, idPayment),
    CONSTRAINT fk_payment_client FOREIGN KEY (idCliente) REFERENCES cliente(idCliente)
);
     
INSERT INTO cliente (Fname, Minit, Lname, CPF, Adress) VALUES
('João', 'A', 'Silva', '12345678901', 'Rua das Flores, 123'),
('Maria', 'B', 'Oliveira', '23456789012', 'Av. Paulista, 500'),
('Carlos', 'C', 'Souza', '34567890123', 'Rua do Comércio, 77');

INSERT INTO product (Pname, classification_kids, category, Avaliação, Size) VALUES
('Notebook', false, 'Eletrônico', 4.5, '1 '),
('Camiseta', false, 'vestimenta', 4.2, 'M'),
('Boneca', true, 'Brinquedos', 4.8, '2');

INSERT INTO payments (idCliente, typePayment, limitAvailable) VALUES
(1, 'Cartão', 1500.00),
(2, 'Boleto', 0.00),
(3, 'Dois cartões', 2000.00);
    
 INSERT INTO orders (idOrderClient, orderStatus, orderDescription, sendValue, paymentcash) VALUES
(1, 'Confirmado', 'Pedido de eletrônicos', 20.00, false),
(2, 'Em processamento', 'Roupas infantis', 15.00, true);   

INSERT INTO productStorage (storageLocation, quantity) VALUES
('Depósito 1', 50),
('Depósito 2', 30);

INSERT INTO supplier (SocialName, CNPJ, contact) VALUES
('Tech Distribuidora', '12345678000199', '11999999999'),
('Moda Ltda', '98765432000188', '11888888888');

INSERT INTO seller (SocialName, AbstName, CNPJ, CPF, location, contact) VALUES
('Eletrônicos S/A', 'Eletrônicos', '11223344000155', '123456789', 'São Paulo - SP', '11911112222'),
('Loja da Moda', 'ModaExpress', '99887766000133', '987654321', 'Belo Horizonte - MG', '11933334444');

 INSERT INTO productSeller (idPseller, idProduct, prodquantity) VALUES
(1, 1, 10),
(2, 2, 20),
(2, 3, 15);   

INSERT INTO productOrder (idPOproduct, idPOorder, poQuantity, poStatus) VALUES
(1, 1, 2, 'Disponível'),
(2, 2, 1, 'Sem estoque');

INSERT INTO storageLocation (idLproduct, idLstorage, location) VALUES
(1, 1, 'Prateleira A1'),
(2, 2, 'Prateleira B2');

    
DROP TABLE IF EXISTS payments;

CREATE TABLE payments (
    idPayment INT AUTO_INCREMENT PRIMARY KEY,
    idCliente INT,
    typePayment ENUM('Boleto','Cartão','Dois cartões'),
    limitAvailable FLOAT,
    CONSTRAINT fk_payment_client FOREIGN KEY (idCliente) REFERENCES cliente(idCliente)
);
    INSERT INTO payments (idCliente, typePayment, limitAvailable) VALUES
(1, 'Cartão', 1500.00),
(2, 'Boleto', 0.00),
(3, 'Dois cartões', 2000.00);

INSERT INTO seller (SocialName, AbstName, CNPJ, CPF, location, contact) VALUES
('Empresa A', 'EmpA', '12345678901234', '123456789', 'São Paulo', '11999999999'),
('Empresa B', 'EmpB', '23456789012345', '987654321', 'Rio de Janeiro', '21988888888');
    SELECT * FROM seller WHERE idSeller IN (1, 2);
   SELECT * FROM product WHERE idProduct IN (1, 2, 3); 
INSERT INTO product (Pname, classification_kids, category, Avaliação, Size) VALUES
('Notebook', false, 'Eletrônico', 4.5, 'Médio'),
('Camiseta', true, 'vestimenta', 4.0, 'M'),
('Boneco', true, 'Brinquedos', 4.8, 'Pequeno');
SELECT * FROM product;
INSERT INTO productSeller (idPseller, idProduct, prodquantity) VALUES
(1, 1, 10),
(2, 2, 20),
(2, 3, 15);
   SELECT * FROM seller WHERE idSeller IN (1, 2); 
    -- Inserir produtos
INSERT INTO product (Pname, classification_kids, category, Avaliação, Size) VALUES
('Notebook', false, 'Eletrônico', 4.5, 'Médio'),
('Camiseta', true, 'vestimenta', 4.0, 'M'),
('Boneco', true, 'Brinquedos', 4.8, 'Pequeno');
  INSERT INTO seller (SocialName, AbstName, CNPJ, CPF, location, contact) VALUES
('Loja Tech Ltda', 'Tech', '0829185845', '123456719', 'São Paulo', '11999999999'),
('Moda Jovem ME', 'ModaJ', '0829185845', '9876543821', 'Rio de Janeiro', '21988888888');  
show tables;
desc cliente;
show tables
select *from database;
SELECT * FROM ecommerce
SELECT * from cliente;
SELECT * FROM orders;
SELECT * FROM seller;
SELECT * FROM productSeller;
SELECT idPseller, idProduct FROM productSeller;

SELECT * FROM productSeller
WHERE prodquantity > 10;

SELECT SUM(prodquantity) AS totalProdutos FROM productSeller;



SELECT * FROM productSeller
WHERE idPseller = 1;

SELECT * FROM productSeller
WHERE prodquantity BETWEEN 10 AND 20;

SELECT
  idPseller,
  idProduct,
  prodquantity,
  price,
  prodquantity * price AS totalValue,
  (prodquantity * price) * 0.9 AS totalComDesconto
FROM
  productSeller
JOIN
  product ON productSeller.idProduct = product.idProduct;
  
  
  SELECT idPseller, COUNT(idProduct) AS totalProdutos
FROM productSeller
GROUP BY idPseller
HAVING COUNT(idProduct) > 15;

SELECT 
  p.Pname,
  s.SocialName AS vendedor,
  ps.prodquantity
FROM productSeller ps
JOIN product p ON ps.idProduct = p.idProduct
JOIN seller s ON ps.idPseller = s.idSeller
ORDER BY ps.prodquantity DESC;


CREATE TABLE if not exists cliente (
    idCliente INT AUTO_INCREMENT PRIMARY KEY,
    tipoCliente ENUM('PF', 'PJ') NOT NULL,
    Fname VARCHAR(50),
    Minit CHAR(3),
    Lname VARCHAR(50),
    Adress VARCHAR(100)
    );
    
    CREATE TABLE clientePF (
    idCliente INT PRIMARY KEY,
    CPF CHAR(11) UNIQUE NOT NULL,
    CONSTRAINT fk_clientePF_cliente FOREIGN KEY (idCliente) REFERENCES cliente(idCliente)
    );
    CREATE TABLE clientePJ (
    idCliente INT PRIMARY KEY,
    CNPJ CHAR(14) UNIQUE NOT NULL,
    RazaoSocial VARCHAR(100),
    CONSTRAINT fk_clientePJ_cliente FOREIGN KEY (idCliente) REFERENCES cliente(idCliente)
);
CREATE TABLE delivery (
    idDelivery INT AUTO_INCREMENT PRIMARY KEY,
    idOrder INT,
    deliveryStatus ENUM('Pendente', 'Em trânsito', 'Entregue', 'Cancelada') DEFAULT 'Pendente',
    trackingCode VARCHAR(50),
    CONSTRAINT fk_delivery_order FOREIGN KEY (idOrder) REFERENCES orders(idOrder)
);
CREATE TABLE delivery (
    idDelivery INT AUTO_INCREMENT PRIMARY KEY,
    idOrder INT,
    deliveryStatus ENUM('Pendente', 'Em trânsito', 'Entregue', 'Cancelada') DEFAULT 'Pendente',
    trackingCode VARCHAR(50),
    CONSTRAINT fk_delivery_order FOREIGN KEY (idOrder) REFERENCES orders(idOrder)
);


-- cliente guarda dados comuns e tipo (PF/PJ).

clientePF e clientePJ armazenam os dados exclusivos de cada tipo, garantindo exclusividade com chave primária compartilhada.

payments tem idPayment autoincrement para suportar várias formas para um cliente.

delivery associa uma entrega a um pedido, com status e código rastreio.



Quantos pedidos foram feitos por cada cliente?
SELECT 
    idOrderClient AS idCliente,
    COUNT(*) AS total_pedidos
FROM 
    orders
GROUP BY 
    idOrderClient;
    
    
    -- Algum vendedor também é fornecedor?
    
    SELECT 
    s.idSeller, s.SocialName AS Vendedor, 
    sup.idSupplier, sup.SocialName AS Fornecedor, 
    s.CNPJ
FROM 
    seller s
INNER JOIN 
    supplier sup ON s.CNPJ = sup.CNPJ;
    
    -- Relação de produtos fornecedores e estoques;


SELECT 
    p.idProduct,
    p.Pname AS Produto,
    s.idSupplier,
    s.SocialName AS Fornecedor,
    ps.quantity AS Quantidade_Fornecedor,
    psStorage.quantity AS Quantidade_Estoque,
    psStorage.storageLocation AS Local_Estoque
FROM 
    productSupplier ps
INNER JOIN 
    supplier s ON ps.idPsSupplier = s.idSupplier
INNER JOIN 
    product p ON ps.idPsProduct = p.idProduct
LEFT JOIN 
    storageLocation sl ON p.idProduct = sl.idLproduct
LEFT JOIN 
    productStorage psStorage ON sl.idLstorage = psStorage.idProdStorage
ORDER BY
    p.Pname, s.SocialName;
    
    
    -- Relação de nomes dos fornecedores e nomes dos produtos;
    
    SELECT 
    s.SocialName AS Nome_Fornecedor,
    p.Pname AS Nome_Produto
FROM 
    supplier s
INNER JOIN 
    productSupplier ps ON s.idSupplier = ps.idPsSupplier
INNER JOIN 
    product p ON ps.idPsProduct = p.idProduct
ORDER BY 
    s.SocialName, p.Pname;