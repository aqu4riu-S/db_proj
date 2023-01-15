DROP TABLE evento_reposicao CASCADE; 
DROP TABLE responsavel_por CASCADE; --
DROP TABLE tem_categoria CASCADE; --
DROP TABLE planograma CASCADE; --
DROP TABLE produto CASCADE; --
DROP TABLE prateleira CASCADE; --
DROP TABLE tem_outra CASCADE; --
DROP TABLE super_categoria CASCADE; --
DROP TABLE categoria_simples CASCADE; --
DROP TABLE categoria CASCADE; --
DROP TABLE instalada_em CASCADE; --
DROP TABLE IVM CASCADE; --
DROP TABLE ponto_de_retalho CASCADE; --
DROP TABLE retalhista CASCADE; --


CREATE TABLE categoria(
    nome VARCHAR(255),
    CONSTRAINT pk_categoria PRIMARY KEY (nome)
    --CONSTRAINT  CHK_CATEGORIA_NOME 
    --CHECK (nome = categoria_simples(nome) OR nome = super_categoria(nome)) --??
);

CREATE TABLE categoria_simples(
    nome VARCHAR(255),
    CONSTRAINT pk_categoria_simples PRIMARY KEY (nome),
    CONSTRAINT fk_categoria_simples FOREIGN KEY (nome) REFERENCES categoria(nome)
    --CHECK (nome != super_categoria(nome))--???
);

CREATE TABLE super_categoria(
    nome VARCHAR(255),
    --CONSTRAINT pk_super_categoria 
    CONSTRAINT pk_super_categoria PRIMARY KEY (nome),
    --CONSTRAINT fk_super_categoria 
    CONSTRAINT fk_super_categoria FOREIGN KEY (nome) REFERENCES categoria(nome)
    --CHECK( nome )
);

CREATE TABLE tem_outra(
    super_categoria VARCHAR(255),
    categoria VARCHAR(255),
    CONSTRAINT pk_tem_outra_categoria PRIMARY KEY (categoria),
    CONSTRAINT fk_tem_outra_super_categoria FOREIGN KEY (super_categoria) REFERENCES super_categoria(nome), 
    CONSTRAINT fk_tem_outra_categoria FOREIGN KEY (categoria) REFERENCES categoria(nome),
    --CHECK ( UNIQUE(fk_tem_outra_categoria)),
    CHECK (super_categoria <> categoria) -- RI-RE5
);

CREATE TABLE produto(
    ean BIGINT, 
    cat VARCHAR(255),
    descr TEXT,
    CONSTRAINT pk_produto PRIMARY KEY (ean),
    CONSTRAINT fk_produto_categoria FOREIGN KEY (cat) REFERENCES categoria(nome)
    --CHECK(ean = fk_tem_categoria_ean)--acho q é assim comas fk, mudar as de cima
);

CREATE TABLE tem_categoria(
    ean BIGINT,
    nome VARCHAR(255),
    CONSTRAINT fk_tem_categoria_ean FOREIGN KEY (ean) REFERENCES produto(ean),
    CONSTRAINT fk_tem_categoria_nome FOREIGN KEY (nome) REFERENCES categoria(nome)
);

CREATE TABLE IVM(
    num_serie BIGINT,
    fabricante VARCHAR(255),
    CONSTRAINT pk_IVM PRIMARY KEY (num_serie, fabricante),
    UNIQUE(num_serie)
);

CREATE TABLE ponto_de_retalho(
    nome VARCHAR(255),
    distrito VARCHAR(255),
    concelho VARCHAR(255),
    CONSTRAINT pk_ponto_de_retalho PRIMARY KEY (nome)
);

CREATE TABLE instalada_em(
    num_serie BIGINT,
    fabricante VARCHAR(255),
    local VARCHAR(255),
    CONSTRAINT pk_instalada_em PRIMARY KEY (num_serie,fabricante),
    CONSTRAINT fk_instalada_em_IVM FOREIGN KEY (num_serie,fabricante) REFERENCES IVM(num_serie,fabricante),
    CONSTRAINT fk_instalada_em_ponto_de_retalho FOREIGN KEY (local) REFERENCES ponto_de_retalho(nome)
);

CREATE TABLE prateleira(
    nro SMALLINT,
    num_serie BIGINT,
    fabricante VARCHAR(255),
    altura SMALLINT,
    nome VARCHAR(255),
    CONSTRAINT pk_prateleira PRIMARY KEY (nro, num_serie, fabricante),
    CONSTRAINT fk_prateleira_IVM FOREIGN KEY (num_serie, fabricante) REFERENCES IVM(num_serie, fabricante),
    CONSTRAINT fk_prateleira_categoria FOREIGN KEY (nome) REFERENCES categoria(nome)
);

CREATE TABLE planograma(
    ean BIGINT,
    nro SMALLINT,
    num_serie BIGINT,
    fabricante VARCHAR(255),
    faces SMALLINT,
    unidades BIGINT,
    loc VARCHAR(255), 
    CONSTRAINT pk_planograma PRIMARY KEY (ean, nro, num_serie, fabricante),
    CONSTRAINT fk_planograma_ean FOREIGN KEY (ean) REFERENCES produto(ean), 
    CONSTRAINT fk_planograma_prateleira FOREIGN KEY (nro, num_serie, fabricante) REFERENCES prateleira(nro, num_serie, fabricante)
);

CREATE TABLE retalhista(
    tin BIGINT,
    name VARCHAR(255),
    CONSTRAINT pk_retalhista PRIMARY KEY (tin),
    UNIQUE (name)
);

CREATE TABLE responsavel_por(
    nome_cat VARCHAR(255),
    tin BIGINT,
    num_serie BIGINT,
    fabricante VARCHAR(255),
    CONSTRAINT pk_responsavel_por PRIMARY KEY (num_serie,fabricante), 
    CONSTRAINT fk_responsavel_por_IVM FOREIGN KEY (num_serie,fabricante) REFERENCES IVM(num_serie, fabricante),
    CONSTRAINT fk_responsavel_por_tin FOREIGN KEY (tin) REFERENCES retalhista(tin),
    CONSTRAINT fk_responsavel_por_nome FOREIGN KEY (nome_cat) REFERENCES categoria(nome)
);

CREATE TABLE evento_reposicao(
    ean BIGINT,
    nro SMALLINT,
    num_serie BIGINT,
    fabricante VARCHAR(255),
    instante TIMESTAMP,
    unidades BIGINT,
    tin BIGINT,
    CONSTRAINT pk_evento_reposicao PRIMARY KEY (ean, nro, num_serie, fabricante, instante),
    CONSTRAINT fk_evento_reposicao_planograma FOREIGN KEY (ean, nro, num_serie, fabricante) REFERENCES planograma(ean, nro, num_serie, fabricante),
    CONSTRAINT fk_evento_reposicao_retalhista FOREIGN KEY (tin) REFERENCES retalhista(tin)
    --CHECK(unidades <= planograma(unidades))--??
);



INSERT INTO retalhista VALUES (111222333, 'Walter Ramirez');
INSERT INTO retalhista VALUES (111222334, 'Cordia Bailey');
INSERT INTO retalhista VALUES (111222335, 'Michelle Valentine');
INSERT INTO retalhista VALUES (111222336, 'Cynthia Mccullough');
INSERT INTO retalhista VALUES (111222337, 'Roger Decker');
INSERT INTO retalhista VALUES (111222338, 'Rolando Fitzgerald');
INSERT INTO retalhista VALUES (111222339, 'Michael Hernandez');




INSERT INTO IVM VALUES (0, 'Warren Mccall');
INSERT INTO IVM VALUES (1, 'James Wright');
INSERT INTO IVM VALUES (2, 'David Russo');
INSERT INTO IVM VALUES (3, 'Wanda Jasper');




INSERT INTO ponto_de_retalho VALUES ('BP Ardegães', 'Porto', 'Maia');
INSERT INTO ponto_de_retalho VALUES ('AB Santana', 'Coimbra', 'Figueira da Foz');




INSERT INTO instalada_em VALUES (0, 'Warren Mccall', 'BP Ardegães');
INSERT INTO instalada_em VALUES (1, 'James Wright', 'BP Ardegães');
INSERT INTO instalada_em VALUES (2, 'David Russo', 'BP Ardegães');
INSERT INTO instalada_em VALUES (3, 'Wanda Jasper', 'AB Santana');




INSERT INTO categoria VALUES ('Milk, lowfat');
INSERT INTO categoria VALUES ('Milk, whole');
INSERT INTO categoria VALUES ('Citrus juice');
INSERT INTO categoria VALUES ('Vegetable juice');
INSERT INTO categoria VALUES ('Diet soft drinks');
INSERT INTO categoria VALUES ('Coffee');
INSERT INTO categoria VALUES ('Beer');
INSERT INTO categoria VALUES ('Tap water');
INSERT INTO categoria VALUES ('Tomato‐based condiments');
INSERT INTO categoria VALUES ('Butter and animal fats');
INSERT INTO categoria VALUES ('Mayonnaise');
INSERT INTO categoria VALUES ('Cheese');
INSERT INTO categoria VALUES ('Apples');
INSERT INTO categoria VALUES ('Rice');
INSERT INTO categoria VALUES ('Yeast breads');
INSERT INTO categoria VALUES ('Biscuits, muffins, quick breads');
INSERT INTO categoria VALUES ('Ready-to-eat cereal, higher sugar');
INSERT INTO categoria VALUES ('Pizza');
INSERT INTO categoria VALUES ('Burgers (single code)');
INSERT INTO categoria VALUES ('Meat mixed dishes');
INSERT INTO categoria VALUES ('Rice mixed dishes');
INSERT INTO categoria VALUES ('Soups');
INSERT INTO categoria VALUES ('Beef, excludes ground');
INSERT INTO categoria VALUES ('Cold cuts and cured meats');
INSERT INTO categoria VALUES ('Chicken, whole pieces');
INSERT INTO categoria VALUES ('Fish');
INSERT INTO categoria VALUES ('Eggs and omelets');
INSERT INTO categoria VALUES ('Nuts and seeds');
INSERT INTO categoria VALUES ('Potato chips');
INSERT INTO categoria VALUES ('Cakes and pies');
INSERT INTO categoria VALUES ('Candy containing chocolate');
INSERT INTO categoria VALUES ('Tomatoes');
INSERT INTO categoria VALUES ('Corn');
INSERT INTO categoria VALUES ('LOWFAT MILK');
INSERT INTO categoria VALUES ('HIGHER FAT MILK');
INSERT INTO categoria VALUES ('100 FRUIT JUICE- VEGETABLE JUICE');
INSERT INTO categoria VALUES ('SUGAR‐ SWEETENED AND DIET BEVERAGES');
INSERT INTO categoria VALUES ('COFFEE AND TEA');
INSERT INTO categoria VALUES ('ALCOHOLIC BEVERAGES');
INSERT INTO categoria VALUES ('WATERS');
INSERT INTO categoria VALUES ('SUGAR- SWEETENED AND DIET BEVERAGES');
INSERT INTO categoria VALUES ('CONDIMENTS AND GRAVIES');
INSERT INTO categoria VALUES ('SPREADS');
INSERT INTO categoria VALUES ('SALAD DRESSINGS');
INSERT INTO categoria VALUES ('LOWFAT MILK/YOGURT');
INSERT INTO categoria VALUES ('HIGHER FAT MILK/YOGURT');
INSERT INTO categoria VALUES ('CHEESE');
INSERT INTO categoria VALUES ('FRUIT');
INSERT INTO categoria VALUES ('100 FRUIT JUICE');
INSERT INTO categoria VALUES ('RICE AND PASTA');
INSERT INTO categoria VALUES ('YEAST BREADS AND TORTILLAS');
INSERT INTO categoria VALUES ('QUICK BREADS');
INSERT INTO categoria VALUES ('BREAKFAST CEREALS AND BARS');
INSERT INTO categoria VALUES ('PIZZA');
INSERT INTO categoria VALUES ('BURGERS AND SANDWICHES');
INSERT INTO categoria VALUES ('MEAT, POULTRY, SEAFOOD MIXED DISHES');
INSERT INTO categoria VALUES ('RICE, PASTA, AND OTHER GRAIN-BASED MIXED DISHES');
INSERT INTO categoria VALUES ('SOUPS');
INSERT INTO categoria VALUES ('MEATS');
INSERT INTO categoria VALUES ('DELI/CURED PRODUCTS');
INSERT INTO categoria VALUES ('POULTRY');
INSERT INTO categoria VALUES ('SEAFOOD');
INSERT INTO categoria VALUES ('EGGS');
INSERT INTO categoria VALUES ('NUTS, SEEDS, AND SOY');
INSERT INTO categoria VALUES ('CHIPS, CRACKERS, AND SAVORY SNACKS');
INSERT INTO categoria VALUES ('DESSERTS AND SWEET SNACKS');
INSERT INTO categoria VALUES ('CANDIES AND SUGARS');
INSERT INTO categoria VALUES ('VEGETABLES');
INSERT INTO categoria VALUES ('STARCHY VEGETABLES');
INSERT INTO categoria VALUES ('ALL BEVERAGES');
INSERT INTO categoria VALUES ('BEVERAGES');
INSERT INTO categoria VALUES ('CONDIMENTS, GRAVIES, SPREADS, SALAD DRESSINGS');
INSERT INTO categoria VALUES ('DAIRY');
INSERT INTO categoria VALUES ('FRUITS AND FRUIT JUICE');
INSERT INTO categoria VALUES ('GRAINS');
INSERT INTO categoria VALUES ('MIXED DISHES');
INSERT INTO categoria VALUES ('PROTEIN FOODS');
INSERT INTO categoria VALUES ('SNACKS AND SWEETS');




INSERT INTO categoria_simples VALUES ('Milk, lowfat');
INSERT INTO categoria_simples VALUES ('Milk, whole');
INSERT INTO categoria_simples VALUES ('Citrus juice');
INSERT INTO categoria_simples VALUES ('Vegetable juice');
INSERT INTO categoria_simples VALUES ('Diet soft drinks');
INSERT INTO categoria_simples VALUES ('Coffee');
INSERT INTO categoria_simples VALUES ('Beer');
INSERT INTO categoria_simples VALUES ('Tap water');
INSERT INTO categoria_simples VALUES ('Tomato‐based condiments');
INSERT INTO categoria_simples VALUES ('Butter and animal fats');
INSERT INTO categoria_simples VALUES ('Mayonnaise');
INSERT INTO categoria_simples VALUES ('Cheese');
INSERT INTO categoria_simples VALUES ('Apples');
INSERT INTO categoria_simples VALUES ('Rice');
INSERT INTO categoria_simples VALUES ('Yeast breads');
INSERT INTO categoria_simples VALUES ('Biscuits, muffins, quick breads');
INSERT INTO categoria_simples VALUES ('Ready-to-eat cereal, higher sugar');
INSERT INTO categoria_simples VALUES ('Pizza');
INSERT INTO categoria_simples VALUES ('Burgers (single code)');
INSERT INTO categoria_simples VALUES ('Meat mixed dishes');
INSERT INTO categoria_simples VALUES ('Rice mixed dishes');
INSERT INTO categoria_simples VALUES ('Soups');
INSERT INTO categoria_simples VALUES ('Beef, excludes ground');
INSERT INTO categoria_simples VALUES ('Cold cuts and cured meats');
INSERT INTO categoria_simples VALUES ('Chicken, whole pieces');
INSERT INTO categoria_simples VALUES ('Fish');
INSERT INTO categoria_simples VALUES ('Eggs and omelets');
INSERT INTO categoria_simples VALUES ('Nuts and seeds');
INSERT INTO categoria_simples VALUES ('Potato chips');
INSERT INTO categoria_simples VALUES ('Cakes and pies');
INSERT INTO categoria_simples VALUES ('Candy containing chocolate');
INSERT INTO categoria_simples VALUES ('Tomatoes');
INSERT INTO categoria_simples VALUES ('Corn');




INSERT INTO super_categoria VALUES ('LOWFAT MILK');
INSERT INTO super_categoria VALUES ('HIGHER FAT MILK');
INSERT INTO super_categoria VALUES ('100 FRUIT JUICE- VEGETABLE JUICE');
INSERT INTO super_categoria VALUES ('SUGAR‐ SWEETENED AND DIET BEVERAGES');
INSERT INTO super_categoria VALUES ('COFFEE AND TEA');
INSERT INTO super_categoria VALUES ('ALCOHOLIC BEVERAGES');
INSERT INTO super_categoria VALUES ('WATERS');
INSERT INTO super_categoria VALUES ('SUGAR- SWEETENED AND DIET BEVERAGES');
INSERT INTO super_categoria VALUES ('CONDIMENTS AND GRAVIES');
INSERT INTO super_categoria VALUES ('SPREADS');
INSERT INTO super_categoria VALUES ('SALAD DRESSINGS');
INSERT INTO super_categoria VALUES ('LOWFAT MILK/YOGURT');
INSERT INTO super_categoria VALUES ('HIGHER FAT MILK/YOGURT');
INSERT INTO super_categoria VALUES ('CHEESE');
INSERT INTO super_categoria VALUES ('FRUIT');
INSERT INTO super_categoria VALUES ('100 FRUIT JUICE');
INSERT INTO super_categoria VALUES ('RICE AND PASTA');
INSERT INTO super_categoria VALUES ('YEAST BREADS AND TORTILLAS');
INSERT INTO super_categoria VALUES ('QUICK BREADS');
INSERT INTO super_categoria VALUES ('BREAKFAST CEREALS AND BARS');
INSERT INTO super_categoria VALUES ('PIZZA');
INSERT INTO super_categoria VALUES ('BURGERS AND SANDWICHES');
INSERT INTO super_categoria VALUES ('MEAT, POULTRY, SEAFOOD MIXED DISHES');
INSERT INTO super_categoria VALUES ('RICE, PASTA, AND OTHER GRAIN-BASED MIXED DISHES');
INSERT INTO super_categoria VALUES ('SOUPS');
INSERT INTO super_categoria VALUES ('MEATS');
INSERT INTO super_categoria VALUES ('DELI/CURED PRODUCTS');
INSERT INTO super_categoria VALUES ('POULTRY');
INSERT INTO super_categoria VALUES ('SEAFOOD');
INSERT INTO super_categoria VALUES ('EGGS');
INSERT INTO super_categoria VALUES ('NUTS, SEEDS, AND SOY');
INSERT INTO super_categoria VALUES ('CHIPS, CRACKERS, AND SAVORY SNACKS');
INSERT INTO super_categoria VALUES ('DESSERTS AND SWEET SNACKS');
INSERT INTO super_categoria VALUES ('CANDIES AND SUGARS');
INSERT INTO super_categoria VALUES ('VEGETABLES');
INSERT INTO super_categoria VALUES ('STARCHY VEGETABLES');
INSERT INTO super_categoria VALUES ('ALL BEVERAGES');
INSERT INTO super_categoria VALUES ('BEVERAGES');
INSERT INTO super_categoria VALUES ('CONDIMENTS, GRAVIES, SPREADS, SALAD DRESSINGS');
INSERT INTO super_categoria VALUES ('DAIRY');
INSERT INTO super_categoria VALUES ('FRUITS AND FRUIT JUICE');
INSERT INTO super_categoria VALUES ('GRAINS');
INSERT INTO super_categoria VALUES ('MIXED DISHES');
INSERT INTO super_categoria VALUES ('PROTEIN FOODS');
INSERT INTO super_categoria VALUES ('SNACKS AND SWEETS');




INSERT INTO tem_outra VALUES ('LOWFAT MILK', 'Milk, lowfat');
INSERT INTO tem_outra VALUES ('HIGHER FAT MILK', 'Milk, whole');
INSERT INTO tem_outra VALUES ('100 FRUIT JUICE- VEGETABLE JUICE', 'Citrus juice');
INSERT INTO tem_outra VALUES ('100 FRUIT JUICE- VEGETABLE JUICE', 'Vegetable juice');
INSERT INTO tem_outra VALUES ('SUGAR‐ SWEETENED AND DIET BEVERAGES', 'Diet soft drinks');
INSERT INTO tem_outra VALUES ('COFFEE AND TEA', 'Coffee');
INSERT INTO tem_outra VALUES ('ALCOHOLIC BEVERAGES', 'Beer');
INSERT INTO tem_outra VALUES ('WATERS', 'Tap water');
INSERT INTO tem_outra VALUES ('SUGAR- SWEETENED AND DIET BEVERAGES', 'Diet soft drinks');
INSERT INTO tem_outra VALUES ('CONDIMENTS AND GRAVIES', 'Tomato‐based condiments');
INSERT INTO tem_outra VALUES ('SPREADS', 'Butter and animal fats');
INSERT INTO tem_outra VALUES ('SALAD DRESSINGS', 'Mayonnaise');
INSERT INTO tem_outra VALUES ('LOWFAT MILK/YOGURT', 'Milk, lowfat');
INSERT INTO tem_outra VALUES ('HIGHER FAT MILK/YOGURT', 'Milk, whole');
INSERT INTO tem_outra VALUES ('CHEESE', 'Cheese');
INSERT INTO tem_outra VALUES ('FRUIT', 'Apples');
INSERT INTO tem_outra VALUES ('100 FRUIT JUICE', 'Citrus juice');
INSERT INTO tem_outra VALUES ('RICE AND PASTA', 'Rice');
INSERT INTO tem_outra VALUES ('YEAST BREADS AND TORTILLAS', 'Yeast breads');
INSERT INTO tem_outra VALUES ('QUICK BREADS', 'Biscuits, muffins, quick breads');
INSERT INTO tem_outra VALUES ('BREAKFAST CEREALS AND BARS', 'Ready-to-eat cereal, higher sugar');
INSERT INTO tem_outra VALUES ('PIZZA', 'Pizza');
INSERT INTO tem_outra VALUES ('BURGERS AND SANDWICHES', 'Burgers (single code)');
INSERT INTO tem_outra VALUES ('MEAT, POULTRY, SEAFOOD MIXED DISHES', 'Meat mixed dishes');
INSERT INTO tem_outra VALUES ('RICE, PASTA, AND OTHER GRAIN-BASED MIXED DISHES', 'Rice mixed dishes');
INSERT INTO tem_outra VALUES ('SOUPS', 'Soups');
INSERT INTO tem_outra VALUES ('MEATS', 'Beef, excludes ground');
INSERT INTO tem_outra VALUES ('DELI/CURED PRODUCTS', 'Cold cuts and cured meats');
INSERT INTO tem_outra VALUES ('POULTRY', 'Chicken, whole pieces');
INSERT INTO tem_outra VALUES ('SEAFOOD', 'Fish');
INSERT INTO tem_outra VALUES ('EGGS', 'Eggs and omelets');
INSERT INTO tem_outra VALUES ('NUTS, SEEDS, AND SOY', 'Nuts and seeds');
INSERT INTO tem_outra VALUES ('CHIPS, CRACKERS, AND SAVORY SNACKS', 'Potato chips');
INSERT INTO tem_outra VALUES ('DESSERTS AND SWEET SNACKS', 'Cakes and pies');
INSERT INTO tem_outra VALUES ('CANDIES AND SUGARS', 'Candy containing chocolate');
INSERT INTO tem_outra VALUES ('VEGETABLES', 'Tomatoes');
INSERT INTO tem_outra VALUES ('ALL BEVERAGES', 'LOWFAT MILK');
INSERT INTO tem_outra VALUES ('ALL BEVERAGES', 'HIGHER FAT MILK');
INSERT INTO tem_outra VALUES ('ALL BEVERAGES', '100 FRUIT JUICE- VEGETABLE JUICE');
INSERT INTO tem_outra VALUES ('ALL BEVERAGES', 'SUGAR‐ SWEETENED AND DIET BEVERAGES');
INSERT INTO tem_outra VALUES ('ALL BEVERAGES', 'COFFEE AND TEA');
INSERT INTO tem_outra VALUES ('ALL BEVERAGES', 'ALCOHOLIC BEVERAGES');
INSERT INTO tem_outra VALUES ('ALL BEVERAGES', 'WATERS');
INSERT INTO tem_outra VALUES ('BEVERAGES', 'SUGAR- SWEETENED AND DIET BEVERAGES');
INSERT INTO tem_outra VALUES ('BEVERAGES', 'COFFEE AND TEA');
INSERT INTO tem_outra VALUES ('BEVERAGES', 'ALCOHOLIC BEVERAGES');
INSERT INTO tem_outra VALUES ('BEVERAGES', 'WATERS');
INSERT INTO tem_outra VALUES ('CONDIMENTS, GRAVIES, SPREADS, SALAD DRESSINGS', 'CONDIMENTS AND GRAVIES');
INSERT INTO tem_outra VALUES ('CONDIMENTS, GRAVIES, SPREADS, SALAD DRESSINGS', 'SPREADS');
INSERT INTO tem_outra VALUES ('CONDIMENTS, GRAVIES, SPREADS, SALAD DRESSINGS', 'SALAD DRESSINGS');
INSERT INTO tem_outra VALUES ('DAIRY', 'LOWFAT MILK/YOGURT');
INSERT INTO tem_outra VALUES ('DAIRY', 'HIGHER FAT MILK/YOGURT');
INSERT INTO tem_outra VALUES ('DAIRY', 'CHEESE');
INSERT INTO tem_outra VALUES ('FRUITS AND FRUIT JUICE', 'FRUIT');
INSERT INTO tem_outra VALUES ('FRUITS AND FRUIT JUICE', '100 FRUIT JUICE');
INSERT INTO tem_outra VALUES ('GRAINS', 'RICE AND PASTA');
INSERT INTO tem_outra VALUES ('GRAINS', 'YEAST BREADS AND TORTILLAS');
INSERT INTO tem_outra VALUES ('GRAINS', 'QUICK BREADS');
INSERT INTO tem_outra VALUES ('GRAINS', 'BREAKFAST CEREALS AND BARS');
INSERT INTO tem_outra VALUES ('MIXED DISHES', 'PIZZA');
INSERT INTO tem_outra VALUES ('MIXED DISHES', 'BURGERS AND SANDWICHES');
INSERT INTO tem_outra VALUES ('MIXED DISHES', 'MEAT, POULTRY, SEAFOOD MIXED DISHES');
INSERT INTO tem_outra VALUES ('MIXED DISHES', 'RICE, PASTA, AND OTHER GRAIN-BASED MIXED DISHES');
INSERT INTO tem_outra VALUES ('MIXED DISHES', 'SOUPS');
INSERT INTO tem_outra VALUES ('PROTEIN FOODS', 'MEATS');
INSERT INTO tem_outra VALUES ('PROTEIN FOODS', 'DELI/CURED PRODUCTS');
INSERT INTO tem_outra VALUES ('PROTEIN FOODS', 'POULTRY');
INSERT INTO tem_outra VALUES ('PROTEIN FOODS', 'SEAFOOD');
INSERT INTO tem_outra VALUES ('PROTEIN FOODS', 'EGGS');
INSERT INTO tem_outra VALUES ('PROTEIN FOODS', 'NUTS, SEEDS, AND SOY');
INSERT INTO tem_outra VALUES ('SNACKS AND SWEETS', 'CHIPS, CRACKERS, AND SAVORY SNACKS');
INSERT INTO tem_outra VALUES ('SNACKS AND SWEETS', 'DESSERTS AND SWEET SNACKS');
INSERT INTO tem_outra VALUES ('SNACKS AND SWEETS', 'CANDIES AND SUGARS');
INSERT INTO tem_outra VALUES ('VEGETABLES', 'VEGETABLES');




INSERT INTO prateleira VALUES (1,0,'Warren Mccall',35,'Diet soft drinks');
INSERT INTO prateleira VALUES (1,1,'James Wright',34,'Milk, lowfat');
INSERT INTO prateleira VALUES (1,2,'David Russo',40,'Milk, lowfat');
INSERT INTO prateleira VALUES (1,3,'Wanda Jasper',30,'Meat mixed dishes');




INSERT INTO produto VALUES (5897746470826,'Milk, lowfat','I remember it all too well');
INSERT INTO produto VALUES (1558052776531,'Milk, whole','And that made me want to die');
INSERT INTO produto VALUES (4929964535711,'Citrus juice','And you were tossing me the car keys');
INSERT INTO produto VALUES (2527357659686,'Vegetable juice','Check the pulse and come back swearing, its the same');
INSERT INTO produto VALUES (6884094611081,'Diet soft drinks','And I know its long gone and');
INSERT INTO produto VALUES (7001235283606,'Coffee','Cause I remember it all, all, all');
INSERT INTO produto VALUES (2994217315034,'Beer','And I might be okay, but Im not fine at all');
INSERT INTO produto VALUES (8785498679163,'Tap water','You taught me bout your past thinkin your future was me');
INSERT INTO produto VALUES (5693670135301,'Diet soft drinks','And I was thinkin on the drive down: Any time now');
INSERT INTO produto VALUES (4622041127326,'Coffee','And he said: Its supposed to be fun');
INSERT INTO produto VALUES (7787377713935,'Beer','I remember it all too well');
INSERT INTO produto VALUES (8101743269221,'Tap water','But Im still tryin to find it');
INSERT INTO produto VALUES (5474318032933,'Tomato‐based condiments','Til we were dead and gone and buried');
INSERT INTO produto VALUES (3422259096955,'Butter and animal fats','They say alls well that ends well');
INSERT INTO produto VALUES (5107170475181,'Mayonnaise','Turning 21');
INSERT INTO produto VALUES (1369684079406,'Milk, lowfat','And how it glistened as it fell');
INSERT INTO produto VALUES (5536083346241,'Milk, whole','And he said: Its supposed to be fun');
INSERT INTO produto VALUES (5949221575055,'Cheese','And then you wondered where it went to as I reached for you');
INSERT INTO produto VALUES (7773379924342,'Apples','You used to be a little kid with glasses in a twin-sized bed');
INSERT INTO produto VALUES (8543800256404,'Citrus juice','Just between us, did the love affair maim you all too well?');
INSERT INTO produto VALUES (9460050992221,'Rice','You never called it what it was');
INSERT INTO produto VALUES (8037821819499,'Yeast breads','Just between us (just between us)m I remember it all too well (wind in my hair)');
INSERT INTO produto VALUES (3411099717207,'Biscuits, muffins, quick breads','It was rare, I was there');
INSERT INTO produto VALUES (3224800520541,'Ready-to-eat cereal, higher sugar','And I know its long gone and');
INSERT INTO produto VALUES (9670638964308,'Pizza','And I know its long gone and');
INSERT INTO produto VALUES (2663943810708,'Burgers (single code)','(I was there, I was there)');
INSERT INTO produto VALUES (8861318978914,'Meat mixed dishes','Willin you to come');
INSERT INTO produto VALUES (1252936205849,'Rice mixed dishes','Back before you lost the one real thing youve ever known');
INSERT INTO produto VALUES (6711732957072,'Soups','After three months in the grave');
INSERT INTO produto VALUES (9466407571958,'Beef, excludes ground','After three months in the grave');
INSERT INTO produto VALUES (2631761908331,'Cold cuts and cured meats','And he said: Its supposed to be fun');
INSERT INTO produto VALUES (3476915015576,'Chicken, whole pieces','And I can picture it after all these days');
INSERT INTO produto VALUES (7102836761722,'Fish','Cause I remember it all, all, all');
INSERT INTO produto VALUES (1243042614329,'Eggs and omelets','Just between us, did the love affair maim you all too well?');
INSERT INTO produto VALUES (6835849125050,'Nuts and seeds','I walked through the door with you, the air was cold');
INSERT INTO produto VALUES (9063717340184,'Potato chips','Now you mail back my things and I walk home alone');
INSERT INTO produto VALUES (5282378951261,'Cakes and pies','And I can picture it after all these days');
INSERT INTO produto VALUES (5200688993262,'Candy containing chocolate','Just between us (just between us)m I remember it all too well (wind in my hair)');
INSERT INTO produto VALUES (9452265761859,'Tomatoes','And I might be okay, but Im not fine at all');
INSERT INTO produto VALUES (4063490055471,'Corn','Autumn leaves fallin down like pieces into place');
INSERT INTO produto VALUES (6455462280127,'Soups','I remember it all too well');
INSERT INTO produto VALUES (3624850201719,'Yeast breads','And you held my lifeless frame');
INSERT INTO produto VALUES (2541474968694,'Milk, lowfat','And I can picture it after all these days');




INSERT INTO planograma VALUES (5693670135301,1,0,'Warren Mccall',2,3,'ghqpkio');
INSERT INTO planograma VALUES (2541474968694,1,1,'James Wright',1,7,'vpbkgml');
INSERT INTO planograma VALUES (5897746470826,1,2,'David Russo',6,19,'ltexipo');
INSERT INTO planograma VALUES (8861318978914,1,3,'Wanda Jasper',1,13,'vhgdhmy');




INSERT INTO tem_categoria VALUES (5897746470826,'Milk, lowfat');
INSERT INTO tem_categoria VALUES (5897746470826,'LOWFAT MILK');
INSERT INTO tem_categoria VALUES (5897746470826,'ALL BEVERAGES');


INSERT INTO tem_categoria VALUES (1558052776531,'Milk, whole');
INSERT INTO tem_categoria VALUES (1558052776531,'HIGHER FAT MILK');
INSERT INTO tem_categoria VALUES (1558052776531,'ALL BEVERAGES');


INSERT INTO tem_categoria VALUES (4929964535711,'Citrus juice');
INSERT INTO tem_categoria VALUES (4929964535711,'100 FRUIT JUICE- VEGETABLE JUICE');
INSERT INTO tem_categoria VALUES (4929964535711,'ALL BEVERAGES');


INSERT INTO tem_categoria VALUES (2527357659686,'Vegetable juice');
INSERT INTO tem_categoria VALUES (2527357659686,'100 FRUIT JUICE- VEGETABLE JUICE');
INSERT INTO tem_categoria VALUES (2527357659686,'ALL BEVERAGES');


INSERT INTO tem_categoria VALUES (6884094611081,'Diet soft drinks');
INSERT INTO tem_categoria VALUES (6884094611081,'SUGAR‐ SWEETENED AND DIET BEVERAGES');
INSERT INTO tem_categoria VALUES (6884094611081,'ALL BEVERAGES');


INSERT INTO tem_categoria VALUES (7001235283606,'Coffee');
INSERT INTO tem_categoria VALUES (7001235283606,'COFFEE AND TEA');
INSERT INTO tem_categoria VALUES (7001235283606,'ALL BEVERAGES');


INSERT INTO tem_categoria VALUES (2994217315034,'Beer');
INSERT INTO tem_categoria VALUES (2994217315034,'ALCOHOLIC BEVERAGES');
INSERT INTO tem_categoria VALUES (2994217315034,'ALL BEVERAGES');


INSERT INTO tem_categoria VALUES (8785498679163,'Tap water');
INSERT INTO tem_categoria VALUES (8785498679163,'WATERS');
INSERT INTO tem_categoria VALUES (8785498679163,'ALL BEVERAGES');


INSERT INTO tem_categoria VALUES (5693670135301,'Diet soft drinks');
INSERT INTO tem_categoria VALUES (5693670135301,'SUGAR‐ SWEETENED AND DIET BEVERAGES');
INSERT INTO tem_categoria VALUES (5693670135301,'ALL BEVERAGES');


INSERT INTO tem_categoria VALUES (4622041127326,'Coffee');
INSERT INTO tem_categoria VALUES (4622041127326,'COFFEE AND TEA');
INSERT INTO tem_categoria VALUES (4622041127326,'ALL BEVERAGES');


INSERT INTO tem_categoria VALUES (7787377713935,'Beer');
INSERT INTO tem_categoria VALUES (7787377713935,'ALCOHOLIC BEVERAGES');
INSERT INTO tem_categoria VALUES (7787377713935,'ALL BEVERAGES');


INSERT INTO tem_categoria VALUES (8101743269221,'Tap water');
INSERT INTO tem_categoria VALUES (8101743269221,'WATERS');
INSERT INTO tem_categoria VALUES (8101743269221,'ALL BEVERAGES');


INSERT INTO tem_categoria VALUES (5474318032933,'Tomato‐based condiments');
INSERT INTO tem_categoria VALUES (5474318032933,'CONDIMENTS AND GRAVIES');
INSERT INTO tem_categoria VALUES (5474318032933,'CONDIMENTS, GRAVIES, SPREADS, SALAD DRESSINGS');


INSERT INTO tem_categoria VALUES (3422259096955,'Butter and animal fats');
INSERT INTO tem_categoria VALUES (3422259096955,'SPREADS');
INSERT INTO tem_categoria VALUES (3422259096955,'CONDIMENTS, GRAVIES, SPREADS, SALAD DRESSINGS');


INSERT INTO tem_categoria VALUES (5107170475181,'Mayonnaise');
INSERT INTO tem_categoria VALUES (5107170475181,'SALAD DRESSINGS');
INSERT INTO tem_categoria VALUES (5107170475181,'CONDIMENTS, GRAVIES, SPREADS, SALAD DRESSINGS');


INSERT INTO tem_categoria VALUES (1369684079406,'Milk, lowfat');
INSERT INTO tem_categoria VALUES (1369684079406,'LOWFAT MILK');
INSERT INTO tem_categoria VALUES (1369684079406,'ALL BEVERAGES');


INSERT INTO tem_categoria VALUES (5536083346241,'Milk, whole');
INSERT INTO tem_categoria VALUES (5536083346241,'HIGHER FAT MILK');
INSERT INTO tem_categoria VALUES (5536083346241,'ALL BEVERAGES');


INSERT INTO tem_categoria VALUES (5949221575055,'Cheese');
INSERT INTO tem_categoria VALUES (5949221575055,'CHEESE');
INSERT INTO tem_categoria VALUES (5949221575055,'DAIRY');


INSERT INTO tem_categoria VALUES (7773379924342,'Apples');
INSERT INTO tem_categoria VALUES (7773379924342,'FRUIT');
INSERT INTO tem_categoria VALUES (7773379924342,'FRUITS AND FRUIT JUICE');


INSERT INTO tem_categoria VALUES (8543800256404,'Citrus juice');
INSERT INTO tem_categoria VALUES (8543800256404,'100 FRUIT JUICE- VEGETABLE JUICE');
INSERT INTO tem_categoria VALUES (8543800256404,'ALL BEVERAGES');


INSERT INTO tem_categoria VALUES (9460050992221,'Rice');
INSERT INTO tem_categoria VALUES (9460050992221,'RICE AND PASTA');
INSERT INTO tem_categoria VALUES (9460050992221,'GRAINS');


INSERT INTO tem_categoria VALUES (8037821819499,'Yeast breads');
INSERT INTO tem_categoria VALUES (8037821819499,'YEAST BREADS AND TORTILLAS');
INSERT INTO tem_categoria VALUES (8037821819499,'GRAINS');


INSERT INTO tem_categoria VALUES (3411099717207,'Biscuits, muffins, quick breads');
INSERT INTO tem_categoria VALUES (3411099717207,'QUICK BREADS');
INSERT INTO tem_categoria VALUES (3411099717207,'GRAINS');


INSERT INTO tem_categoria VALUES (3224800520541,'Ready-to-eat cereal, higher sugar');
INSERT INTO tem_categoria VALUES (3224800520541,'BREAKFAST CEREALS AND BARS');
INSERT INTO tem_categoria VALUES (3224800520541,'GRAINS');


INSERT INTO tem_categoria VALUES (9670638964308,'Pizza');
INSERT INTO tem_categoria VALUES (9670638964308,'PIZZA');
INSERT INTO tem_categoria VALUES (9670638964308,'MIXED DISHES');


INSERT INTO tem_categoria VALUES (2663943810708,'Burgers (single code)');
INSERT INTO tem_categoria VALUES (2663943810708,'BURGERS AND SANDWICHES');
INSERT INTO tem_categoria VALUES (2663943810708,'MIXED DISHES');


INSERT INTO tem_categoria VALUES (8861318978914,'Meat mixed dishes');
INSERT INTO tem_categoria VALUES (8861318978914,'MEAT, POULTRY, SEAFOOD MIXED DISHES');
INSERT INTO tem_categoria VALUES (8861318978914,'MIXED DISHES');


INSERT INTO tem_categoria VALUES (1252936205849,'Rice mixed dishes');
INSERT INTO tem_categoria VALUES (1252936205849,'RICE, PASTA, AND OTHER GRAIN-BASED MIXED DISHES');
INSERT INTO tem_categoria VALUES (1252936205849,'MIXED DISHES');


INSERT INTO tem_categoria VALUES (6711732957072,'Soups');
INSERT INTO tem_categoria VALUES (6711732957072,'SOUPS');
INSERT INTO tem_categoria VALUES (6711732957072,'MIXED DISHES');


INSERT INTO tem_categoria VALUES (9466407571958,'Beef, excludes ground');
INSERT INTO tem_categoria VALUES (9466407571958,'MEATS');
INSERT INTO tem_categoria VALUES (9466407571958,'PROTEIN FOODS');


INSERT INTO tem_categoria VALUES (2631761908331,'Cold cuts and cured meats');
INSERT INTO tem_categoria VALUES (2631761908331,'DELI/CURED PRODUCTS');
INSERT INTO tem_categoria VALUES (2631761908331,'PROTEIN FOODS');


INSERT INTO tem_categoria VALUES (3476915015576,'Chicken, whole pieces');
INSERT INTO tem_categoria VALUES (3476915015576,'POULTRY');
INSERT INTO tem_categoria VALUES (3476915015576,'PROTEIN FOODS');


INSERT INTO tem_categoria VALUES (7102836761722,'Fish');
INSERT INTO tem_categoria VALUES (7102836761722,'SEAFOOD');
INSERT INTO tem_categoria VALUES (7102836761722,'PROTEIN FOODS');


INSERT INTO tem_categoria VALUES (1243042614329,'Eggs and omelets');
INSERT INTO tem_categoria VALUES (1243042614329,'EGGS');
INSERT INTO tem_categoria VALUES (1243042614329,'PROTEIN FOODS');


INSERT INTO tem_categoria VALUES (6835849125050,'Nuts and seeds');
INSERT INTO tem_categoria VALUES (6835849125050,'NUTS, SEEDS, AND SOY');
INSERT INTO tem_categoria VALUES (6835849125050,'PROTEIN FOODS');


INSERT INTO tem_categoria VALUES (9063717340184,'Potato chips');
INSERT INTO tem_categoria VALUES (9063717340184,'CHIPS, CRACKERS, AND SAVORY SNACKS');
INSERT INTO tem_categoria VALUES (9063717340184,'SNACKS AND SWEETS');


INSERT INTO tem_categoria VALUES (5282378951261,'Cakes and pies');
INSERT INTO tem_categoria VALUES (5282378951261,'DESSERTS AND SWEET SNACKS');
INSERT INTO tem_categoria VALUES (5282378951261,'SNACKS AND SWEETS');


INSERT INTO tem_categoria VALUES (5200688993262,'Candy containing chocolate');
INSERT INTO tem_categoria VALUES (5200688993262,'CANDIES AND SUGARS');
INSERT INTO tem_categoria VALUES (5200688993262,'SNACKS AND SWEETS');


INSERT INTO tem_categoria VALUES (9452265761859,'Tomatoes');
INSERT INTO tem_categoria VALUES (9452265761859,'VEGETABLES');
INSERT INTO tem_categoria VALUES (9452265761859,'VEGETABLES');


INSERT INTO tem_categoria VALUES (4063490055471,'Corn');
INSERT INTO tem_categoria VALUES (4063490055471,'STARCHY VEGETABLES');
INSERT INTO tem_categoria VALUES (4063490055471,'VEGETABLES');


INSERT INTO tem_categoria VALUES (6455462280127,'Soups');
INSERT INTO tem_categoria VALUES (6455462280127,'SOUPS');
INSERT INTO tem_categoria VALUES (6455462280127,'MIXED DISHES');


INSERT INTO tem_categoria VALUES (3624850201719,'Yeast breads');
INSERT INTO tem_categoria VALUES (3624850201719,'YEAST BREADS AND TORTILLAS');
INSERT INTO tem_categoria VALUES (3624850201719,'GRAINS');


INSERT INTO tem_categoria VALUES (2541474968694,'Milk, lowfat');
INSERT INTO tem_categoria VALUES (2541474968694,'LOWFAT MILK');
INSERT INTO tem_categoria VALUES (2541474968694,'ALL BEVERAGES');






INSERT INTO responsavel_por VALUES ('Diet soft drinks',111222337,0,'Warren Mccall');
INSERT INTO responsavel_por VALUES ('Milk, lowfat',111222335,1,'James Wright');
INSERT INTO responsavel_por VALUES ('Milk, lowfat',111222337,2,'David Russo');
INSERT INTO responsavel_por VALUES ('Meat mixed dishes',111222339,3,'Wanda Jasper');




INSERT INTO evento_reposicao VALUES (8861318978914,1,3,'Wanda Jasper','2022-06-23 20:16:11',1,111222339);
INSERT INTO evento_reposicao VALUES (5693670135301,1,0,'Warren Mccall','2022-06-06 13:07:32',3,111222337);
INSERT INTO evento_reposicao VALUES (5693670135301,1,0,'Warren Mccall','2022-06-03 20:50:57',1,111222337);
INSERT INTO evento_reposicao VALUES (2541474968694,1,1,'James Wright','2022-06-24 08:54:58',2,111222335);
INSERT INTO evento_reposicao VALUES (8861318978914,1,3,'Wanda Jasper','2022-06-15 09:29:20',9,111222339);
INSERT INTO evento_reposicao VALUES (8861318978914,1,3,'Wanda Jasper','2022-06-23 04:29:30',11,111222339);
INSERT INTO evento_reposicao VALUES (8861318978914,1,3,'Wanda Jasper','2022-06-11 13:53:22',8,111222339);
INSERT INTO evento_reposicao VALUES (5693670135301,1,0,'Warren Mccall','2022-06-03 20:40:09',1,111222337);
INSERT INTO evento_reposicao VALUES (8861318978914,1,3,'Wanda Jasper','2022-06-05 16:09:16',3,111222339);
INSERT INTO evento_reposicao VALUES (8861318978914,1,3,'Wanda Jasper','2022-06-03 01:16:49',3,111222339);
INSERT INTO evento_reposicao VALUES (8861318978914,1,3,'Wanda Jasper','2022-06-21 20:06:44',2,111222339);
INSERT INTO evento_reposicao VALUES (2541474968694,1,1,'James Wright','2022-06-17 03:08:41',2,111222335);
INSERT INTO evento_reposicao VALUES (2541474968694,1,1,'James Wright','2022-06-22 22:50:09',7,111222335);
INSERT INTO evento_reposicao VALUES (5897746470826,1,2,'David Russo','2022-06-14 17:58:28',16,111222337);
INSERT INTO evento_reposicao VALUES (5897746470826,1,2,'David Russo','2022-06-10 19:33:33',18,111222337);
INSERT INTO evento_reposicao VALUES (2541474968694,1,1,'James Wright','2022-06-11 08:12:13',2,111222335);
INSERT INTO evento_reposicao VALUES (5693670135301,1,0,'Warren Mccall','2022-06-03 19:02:20',2,111222337);
INSERT INTO evento_reposicao VALUES (5897746470826,1,2,'David Russo','2022-06-20 15:43:14',17,111222337);
INSERT INTO evento_reposicao VALUES (5693670135301,1,0,'Warren Mccall','2022-06-17 03:26:24',2,111222337);
INSERT INTO evento_reposicao VALUES (2541474968694,1,1,'James Wright','2022-06-06 04:41:14',2,111222335);
INSERT INTO evento_reposicao VALUES (5693670135301,1,0,'Warren Mccall','2022-06-16 15:21:29',2,111222337);
INSERT INTO evento_reposicao VALUES (8861318978914,1,3,'Wanda Jasper','2022-06-19 14:07:35',1,111222339);
INSERT INTO evento_reposicao VALUES (5897746470826,1,2,'David Russo','2022-06-22 04:06:24',2,111222337);
INSERT INTO evento_reposicao VALUES (5693670135301,1,0,'Warren Mccall','2022-06-10 15:02:27',3,111222337);
INSERT INTO evento_reposicao VALUES (5897746470826,1,2,'David Russo','2022-06-21 02:39:15',3,111222337);
INSERT INTO evento_reposicao VALUES (2541474968694,1,1,'James Wright','2022-06-09 00:10:02',6,111222335);
INSERT INTO evento_reposicao VALUES (5693670135301,1,0,'Warren Mccall','2022-06-17 13:53:45',2,111222337);
INSERT INTO evento_reposicao VALUES (8861318978914,1,3,'Wanda Jasper','2022-06-11 12:11:15',5,111222339);
INSERT INTO evento_reposicao VALUES (5693670135301,1,0,'Warren Mccall','2022-06-16 11:29:28',1,111222337);
INSERT INTO evento_reposicao VALUES (2541474968694,1,1,'James Wright','2022-06-07 15:02:17',5,111222335);
