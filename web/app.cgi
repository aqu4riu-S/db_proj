#!/usr/bin/python3
#coding=latin-1
from wsgiref.handlers import CGIHandler 
from flask import Flask, render_template, request
import psycopg2 # Libs postgres
import psycopg2.extras


## SGBD configs
DB_HOST='db.tecnico.ulisboa.pt'
DB_USER='ist199295' 
DB_DATABASE=DB_USER
DB_PASSWORD='zhgs1991'
DB_CONNECTION_STRING = 'host=%s dbname=%s user=%s password=%s' % (DB_HOST, DB_DATABASE, DB_USER, DB_PASSWORD)


app = Flask(__name__)



@app.route('/menu')
def index():
    return render_template('index.html')


@app.route('/menu/ivms', methods=['GET'])
def list_ivms():

    dbConn = None
    cursor = None

    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)

        query = 'SELECT * FROM IVM;'

        cursor.execute(query)

        return render_template('ivms.html', cursor=cursor)


    except Exception as e:
        return str(e) # Renders a page with the error.
    finally:
        cursor.close()
        dbConn.close() 




@app.route('/menu/categorias', methods=['GET'])
def list_categorias():

    dbConn = None
    cursor = None

    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)

        query = 'SELECT * FROM categoria;'

        cursor.execute(query)

        return render_template('categorias.html', cursor=cursor)


    except Exception as e:
        return str(e) # Renders a page with the error.
    finally:
        cursor.close()
        dbConn.close() 



@app.route('/super_categorias', methods=['GET'])

def list_super_categorias():

    dbConn = None
    cursor = None

    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)

        query = 'SELECT * FROM super_categoria;'

        cursor.execute(query)

        return render_template('super_categorias.html', cursor=cursor)


    except Exception as e:
        return str(e) # Renders a page with the error.
    finally:
        cursor.close()
        dbConn.close() 



@app.route('/categorias_simples', methods=['GET'])

def list_categorias_simples():

    dbConn = None
    cursor = None

    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)

        query = 'SELECT * FROM categoria_simples;'

        cursor.execute(query)

        return render_template('categorias_simples.html', cursor=cursor)


    except Exception as e:
        return str(e) # Renders a page with the error.
    finally:
        cursor.close()
        dbConn.close() 





@app.route('/produtos', methods=['GET'])

def list_produtos():

    dbConn = None
    cursor = None

    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)

        query = 'SELECT * FROM produto;'

        cursor.execute(query)

        return render_template('produtos.html', cursor=cursor)


    except Exception as e:
        return str(e) # Renders a page with the error.
    finally:
        cursor.close()
        dbConn.close() 








@app.route('/retalhistas', methods=['GET'])

def list_retalhistas():

    dbConn = None
    cursor = None

    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)

        query = 'SELECT name FROM retalhista;'

        cursor.execute(query)

        return render_template('retalhistas.html', cursor=cursor)


    except Exception as e:
        return str(e) # Renders a page with the error.
    finally:
        cursor.close()
        dbConn.close() 




@app.route('/retalhistas', methods=['POST', 'PUT'])

def inserir_retalhista():

    dbConn = None
    cursor = None

    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)

        if request.method == 'POST':
            
            tin = request.form['tin']
            name = request.form['name']
            query = f'INSERT INTO retalhista VALUES (%s, %s);'


            cursor.execute(query, (tin, name))

            # Applying changes
            dbConn.commit()

            return list_retalhistas()


    except Exception as e:
        return str(e) # Renders a page with the error.
    finally:

        cursor.close()
        dbConn.close() 




@app.route('/retalhistas/<name>', methods=['GET', 'DELETE'])

def remover_retalhista(name):

    dbConn = None
    cursor = None

    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)

        query_tin = f'SELECT tin FROM retalhista WHERE name = %s;'
        cursor.execute(query_tin, (name,))
        row = cursor.fetchone()


        query_er = f'DELETE FROM evento_reposicao WHERE tin = %s;'
        query_rp = f'DELETE FROM responsavel_por WHERE tin = %s;'
        query = f'DELETE FROM retalhista WHERE name = %s;'


        cursor.execute(query_er, (row[0],))
        cursor.execute(query_rp, (row[0],))
        cursor.execute(query, (name,))

        dbConn.commit()

        return list_retalhistas()


    except Exception as e:
        return str(e) # Renders a page with the error.
    finally:
        cursor.close()
        dbConn.close() 







@app.route('/list_eventos_reposicao/<num_serie>/<fabricante>', methods=['GET'])

def list_eventos_reposicao(num_serie, fabricante):

    dbConn = None
    cursor = None

    try: 
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)

        query1 = f'SELECT * FROM evento_reposicao \
                    WHERE num_serie = %s \
                        AND fabricante = %s;'

        #query2 = f'SELECT cat, SUM(unidades) tot_unidades_repostas \
                    #FROM evento_reposicao er JOIN produto p ON er.ean = p.ean \
                    #WHERE num_serie = %s AND fabricante = %s \
                    #GROUP BY cat;'

        #queries = [query1, query2]
        #cursor.execute(';'.join(queries), (num_serie, fabricante), multi=True)
        cursor.execute(query1, (num_serie, fabricante))
        return render_template('list_eventos_reposicao.html', cursor=cursor) 
        # ~/web/templates/list_eventos_reposicao.html

    except Exception as e:
        return str(e) # Renders a page with the error.
    finally:
        cursor.close()
        dbConn.close() 

# CGIHandler().run(app)



@app.route('/list_sub_categorias/<categoria>', methods=['GET', 'POST'])

def list_sub_categorias(categoria):

    dbConn = None
    cursor = None

    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)

        super_categoria = categoria
        sub_lst = []

        

        query = f'SELECT categoria \
                FROM super_categoria s JOIN tem_outra t ON s.nome = t.super_categoria \
                WHERE s.nome = %s;'

        super_lst = [super_categoria]
                

        while super_lst:
            cursor.execute(query, (super_lst[0],))
            for row in cursor.fetchall():
                super_lst.append(row[0])
                sub_lst.append(row[0])
            super_lst.pop(0)

        return render_template('list_sub_categorias.html', sub_lst=sub_lst, super_categoria=super_categoria, params=request.args)
        
    except Exception as e:
        return str(e) # Renders a page with the error.
    finally:
        cursor.close()
        dbConn.close() 
        



# request.method == 'POST'
# diferenciar post de get na funcao de baixo ?



@app.route('/super_categorias', methods=['POST', 'PUT']) 

def inserir_categoria():

    dbConn = None
    cursor = None

    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor) 

        categoria, sub_categoria = "", ""
        if request.method == 'POST':
            categoria = request.form['categoria']
            sub_categoria = request.form['sub_categoria']

            query1 = f'INSERT INTO categoria VALUES (%s);'
            query2 = f'INSERT INTO super_categoria VALUES (%s);'
            # query3 = f'INSERT INTO categoria VALUES (%s)'
            query4 = f'INSERT INTO tem_outra VALUES (%s, %s)'

            cursor.execute(query1, (categoria,))
            cursor.execute(query2, (categoria,))
            # cursor.execute(query3, (sub_categoria,))
            cursor.execute(query4, (categoria, sub_categoria))

            # return render_template('/web/templates/super_categorias.html', cursor=cursor)

    except Exception as e:
        return str(e) # Renders a page with the error.
    finally:

        # Applying changes
        dbConn.commit()

        cursor.close()
        dbConn.close()

        return list_categorias()

    




@app.route('/super_categorias/<categoria>', methods=['DELETE', 'GET'])


def remover_categoria(categoria):

    dbConn = None
    cursor = None

    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor) 


        # categoria = request.form['categoria']


        query_resp_por = f'DELETE FROM responsavel_por WHERE nome_cat = %s;'
        # precisamos de remover o retalhista tbm? ou checkar se ele tem mais categorias
        # pelas quais eh responsavel e so o remover caso n tenha mais nenhuma ? ...


        # um produto s  pode ter associado a ele, diretamente, uma categoria simples neh?
        query_tem_cat = f'DELETE FROM tem_categoria WHERE nome = %s;'

        query_produto = f'DELETE FROM produto WHERE cat = %s;'


        # se uma categoria simples deixa de ter a super a ela associada removemos tbm ??

        # no caso de esta ter uma super categoria que a engloba
        query_tem_outra = f'DELETE FROM tem_outra WHERE categoria = %s;'

        # remover todas as entradas em que eh uma super categoria
        query_tem_outra_2 = f'DELETE FROM tem_outra WHERE super_categoria = %s;'

        query_super_cat = f'DELETE FROM super_categoria WHERE nome = %s;'

        query_cat = f'DELETE FROM categoria WHERE nome = %s;'


        cursor.execute(query_resp_por, (categoria,))
        cursor.execute(query_tem_cat, (categoria,))
        cursor.execute(query_produto, (categoria,))
        cursor.execute(query_tem_outra, (categoria,))
        cursor.execute(query_super_cat, (categoria,))
        cursor.execute(query_cat, (categoria,))

        # Applying changes
        dbConn.commit()
       
        return list_super_categorias()

    except Exception as e:
        return str(e) # Renders a page with the error.
    finally:

        cursor.close()
        dbConn.close() 





@app.route('/categorias_simples', methods=['PUT', 'POST']) 

def inserir_sub_categoria():

    dbConn = None
    cursor = None

    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor) 

        sub_categoria = ""
        if request.method == 'POST': 
            # Get data from form
            sub_categoria = request.form['sub_categoria']
        
            # SQL queries
            query1 = f'INSERT INTO categoria VALUES (%s);'
            query2 = f'INSERT INTO categoria_simples VALUES (%s);'

            # Adding data
            cursor.execute(query1, (sub_categoria,))
            cursor.execute(query2, (sub_categoria,))


    except Exception as e:
        return str(e) # Renders a page with the error.
    finally:

        # Applying changes
        dbConn.commit()

        cursor.close()
        dbConn.close() 

        return list_categorias_simples()
        # return render_template('/web/templates/list_eventos_reposicao.html', cursor=cursor)




# duvida: como passar argumentos para as multiplas queries no cursor.execute() ??



@app.route('/categorias_simples/<sub_categoria>', methods=['DELETE', 'GET']) 

def remover_sub_categoria(sub_categoria):

    dbConn = None
    cursor = None

    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor) 


        # sub_categoria = request.form['sub_categoria']


        query_resp_por = f'DELETE FROM responsavel_por WHERE nome_cat = %s;'
        # precisamos de remover o retalhista tbm? ou checkar se ele tem mais categorias
        # pelas quais eh responsavel e so o remover caso n tenha mais nenhuma ? ...

        query_tem_cat = f'DELETE FROM tem_categoria WHERE nome = %s;'

        query_produto = f'DELETE FROM produto WHERE cat = %s;'



        query_tem_outra = f'DELETE FROM tem_outra WHERE categoria = %s;'

        # SELECT super_categoria FROM tem_outra WHERE categoria = sub_categoria;
        # ver se alguma super_categoria ficou sem ligacoes na tabela tem_outra e,
        # em caso afirmativo, DELETE dessa super categoria em super_categoria e em
        # categoria


        query_cat_simples = f'DELETE FROM categoria_simples WHERE nome = %s;'

        query_cat = f'DELETE FROM categoria WHERE nome = %s;'


        cursor.execute(query_resp_por, (sub_categoria,))
        cursor.execute(query_tem_cat, (sub_categoria,))
        cursor.execute(query_produto, (sub_categoria,))
        cursor.execute(query_tem_outra, (sub_categoria,))
        cursor.execute(query_cat_simples, (sub_categoria,))
        cursor.execute(query_cat, (sub_categoria,))

        # Applying changes
        dbConn.commit()

       
        return list_categorias_simples()

    except Exception as e:
        return str(e) # Renders a page with the error.
    finally:

        cursor.close()
        dbConn.close() 

# forms com metodo POST (e nao GET)!
# Modo correto de passar variaveis de comandos sql
CGIHandler().run(app)




