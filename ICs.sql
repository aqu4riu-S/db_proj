---------------------- RI-1 ------------------
/* (RI-1) Uma Categoria não pode estar contida em si própria */
/*
CREATE OR REPLACE FUNCTION chk_tem_outra()
RETURNS TRIGGER AS
$$
BEGIN

    IF NEW.super_categoria = NEW.categoria THEN
        RAISE EXCEPTION 'A category can not be contained in itself : % as a super category of % not allowed',
                                                      NEW.super_categoria, NEW.categoria;

    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER chk_tem_outra BEFORE INSERT
ON tem_outra
FOR EACH ROW EXECUTE PROCEDURE chk_tem_outra();
*/



-------------------- RI-4 -----------------------------
/* (RI-5) Um Produto só pode ser reposto numa Prateleira 
que apresente (pelo menos) uma das Categorias desse produto */

CREATE OR REPLACE FUNCTION chk_units_for_replenishment()
RETURNS TRIGGER AS
$$
DECLARE unidades_planograma INT;
BEGIN

    SELECT unidades INTO unidades_planograma
    FROM planograma p
    WHERE NEW.ean=p.ean AND NEW.nro=p.nro AND NEW.num_serie=p.num_serie 
    AND NEW.fabricante=p.fabricante;  

    -- assumir value_ultrapassa -> max_allowed ou dar raise de excecao?
    IF NEW.unidades > unidades_planograma THEN
        --NEW.unidades := unidades_planograma;
        RAISE EXCEPTION 'Replenished units cannot surpass the 
        maximum value defined in planogram : % > % not allowed',
                                                      NEW.unidades, unidades_planograma;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;



CREATE TRIGGER chk_units_for_replenishment BEFORE INSERT
ON evento_reposicao
--WHEN <condition>
FOR EACH ROW EXECUTE PROCEDURE chk_units_for_replenishment();





--------------------- RI-5 ---------------------------
/* (RI-5) Um Produto só pode ser reposto numa Prateleira 
que apresente (pelo menos) uma das Categorias desse produto */
-- equivalente a RI-RE8


CREATE OR REPLACE FUNCTION chk_same_category()
RETURNS TRIGGER AS
$$
DECLARE prat_cat varchar;
DECLARE prod_cat varchar;
BEGIN

    SELECT nome
    INTO prat_cat
    FROM prateleira p
    WHERE NEW.nro = p.nro AND NEW.num_serie = p.num_serie AND NEW.fabricante = p.fabricante;

    SELECT cat
    INTO prod_cat
    FROM produto prod
    WHERE NEW.ean = prod.ean;
    
    -- assumir value_ultrapassa -> max_allowed ou dar raise de excecao?
    IF prat_cat <> prod_cat THEN
        RAISE EXCEPTION 'A product can only be replenished in a shelf
            that has, at least, one category of such product : % <> % not allowed',
                                                      prat_cat, prod_cat;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;



CREATE TRIGGER chk_same_category BEFORE INSERT
ON evento_reposicao
--WHEN <condition>
FOR EACH ROW EXECUTE PROCEDURE chk_same_category();

--------------------- RI-RE2 ---------------------------

/*
CREATE OR REPLACE FUNCTION chk_categoria_simples()
RETURNS TRIGGER AS
$$

DECLARE simple_category VARCHAR; 
DECLARE current_super_category VARCHAR;
DECLARE cursor_super_categoria CURSOR FOR
        SELECT nome FROM super_categoria;

BEGIN
    simple_category := NEW.nome;
    OPEN cursor_super_categoria;
    LOOP
        FETCH cursor_super_categoria INTO current_super_category;

        IF simple_category = current_super_category THEN
            RAISE EXCEPTION 'A simple category can not be a super category : % (simple category) = % (super category) not allowed',
                                                      simple_category, current_super_category;
        END IF;
    
    END LOOP;
    CLOSE cursor_super_categoria;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER chk_categoria_simples BEFORE INSERT
ON categoria_simples
FOR EACH ROW EXECUTE PROCEDURE chk_categoria_simples();
*/


