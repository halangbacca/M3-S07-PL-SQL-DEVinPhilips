SELECT * FROM Produto;
SELECT * FROM ProdutoPreco;

DROP TABLE ProdutoPreco CASCADE CONSTRAINTS;


-- Exercício 1
DECLARE
	v_id NUMBER;
	CURSOR cAtualizarStatusProduto IS SELECT Id FROM Produto WHERE Id IN (1, 2, 3);

BEGIN    
    OPEN cAtualizarStatusProduto;
        LOOP
            FETCH cAtualizarStatusProduto INTO v_id;
                EXIT WHEN cAtualizarStatusProduto%NOTFOUND;
                
                UPDATE Produto SET Status = 0 WHERE Id = v_id;
        END LOOP;
    CLOSE cAtualizarStatusProduto;
END;

-- Exercícios 2, 3 e 4
CREATE OR REPLACE PROCEDURE ExibirTodosProdutos
IS
	v_id NUMBER;
	v_status NUMBER;
	v_valor NUMBER (10, 2);
	CURSOR cListarDadosProdutoPreco IS SELECT Id, Status, Valor FROM ProdutoPreco;
BEGIN    
    OPEN cListarDadosProdutoPreco;
        LOOP
            FETCH cListarDadosProdutoPreco INTO v_id, v_status, v_valor;
                EXIT WHEN cListarDadosProdutoPreco%NOTFOUND;
                
               	IF v_status = 1 THEN
                	DBMS_OUTPUT.PUT_LINE('Status ativo');
                ELSE
                	DBMS_OUTPUT.PUT_LINE('Status inativo');
                END IF;
               
               	IF v_valor < 1000.00 THEN
                	DBMS_OUTPUT.PUT_LINE('Valor menor que R$ 1000,00');
                ELSE
                	DBMS_OUTPUT.PUT_LINE('Valor maior que R$ 1000,00');
                END IF;
        END LOOP;
       
     EXCEPTION
     	WHEN NO_DATA_FOUND THEN
     		DBMS_OUTPUT.PUT_LINE('Erro: dados não encontrados! ' || SQLCODE);
       
     CLOSE cListarDadosProdutoPreco;
     	
END;

CALL SYSTEM.ExibirTodosProdutos();