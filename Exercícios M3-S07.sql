SELECT * FROM Produto;
SELECT * FROM ProdutoPreco;

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

-- Exercício 2
DECLARE
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
    CLOSE cListarDadosProdutoPreco;
END;

-- Exercício 3
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
    CLOSE cListarDadosProdutoPreco;
END;

CALL SYSTEM.ExibirTodosProdutos();