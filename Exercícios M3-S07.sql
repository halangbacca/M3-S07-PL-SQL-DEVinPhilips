SELECT * FROM Produto;
SELECT * FROM ProdutoPreco;

INSERT INTO Produto(Id, Descricao, Status, Cadastro, QuantidadeEmEstoque)
	VALUES(11, 'PRODUTO A', 1, TO_DATE('2023-01-01', 'YYYY-MM-DD'), 200);

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
CREATE OR REPLACE PROCEDURE ExibirTodosProdutos IS
	v_id NUMBER;
	v_status NUMBER;
	v_valor NUMBER (10, 2);
	CURSOR cListarDadosProdutoPreco IS SELECT Id, Status, Valor FROM ProdutoPreco ORDER BY Valor;
BEGIN
	OPEN cListarDadosProdutoPreco;
		LOOP
			FETCH cListarDadosProdutoPreco INTO v_id, v_status, v_valor;
				EXIT WHEN cListarDadosProdutoPreco%NOTFOUND;
                
               	IF v_status = 1 THEN
                	DBMS_OUTPUT.PUT_LINE('ID: ' || v_id || ' - status ativo');
                ELSE
                	DBMS_OUTPUT.PUT_LINE('ID: ' || v_id || ' - status inativo');
                END IF;
               
               	IF v_valor < 1000.00 THEN
                	DBMS_OUTPUT.PUT_LINE('ID: ' || v_id || ' - valor menor que R$ 1000,00');
                ELSE
                	DBMS_OUTPUT.PUT_LINE('ID: ' || v_id || ' - valor maior que R$ 1000,00');
                END IF;
        END LOOP;
    CLOSE cListarDadosProdutoPreco;

    EXCEPTION
    	WHEN NO_DATA_FOUND THEN
    		DBMS_OUTPUT.PUT_LINE('Erro! Dados não encontrados');
     		DBMS_OUTPUT.PUT_LINE('Código do erro: ' || SQLCODE);
       
END;

CALL SYSTEM.ExibirTodosProdutos();

-- Exercício 5
CREATE OR REPLACE PROCEDURE AtualizarProdutoPreco(pIdProduto NUMBER, pValorProduto NUMBER) IS
	ProdutoInexistente EXCEPTION;
    StatusDesativado   EXCEPTION;
   
    PRAGMA EXCEPTION_INIT(ProdutoInexistente, -20001);
    PRAGMA EXCEPTION_INIT(StatusDesativado, -20002);
   
BEGIN
	FOR produto IN (SELECT * FROM ProdutoPreco) LOOP
		IF pIdProduto NOT IN (produto.id) THEN
			RAISE ProdutoInexistente;
		ELSIF produto.Status = 0 THEN
			RAISE StatusDesativado;
		ELSE
    		UPDATE ProdutoPreco SET Valor = pValorProduto WHERE Id = pIdProduto;
    	END IF;
    END LOOP;
   
EXCEPTION
	WHEN ProdutoInexistente THEN
		DBMS_OUTPUT.PUT_LINE('Produto inexistente!');
		DBMS_OUTPUT.PUT_LINE('Código do erro: ' || SQLCODE);
	WHEN StatusDesativado THEN
		DBMS_OUTPUT.PUT_LINE('Produto está desativado na tabela!');
		DBMS_OUTPUT.PUT_LINE('Código do erro: ' || SQLCODE);
	
END;

CALL SYSTEM.AtualizarProdutoPreco(1, '100,00'); -- Produto desativado
CALL SYSTEM.AtualizarProdutoPreco(20, '20,00'); -- Produto inexistente

SELECT * FROM ProdutoPreco;

-- Exercício 6
CREATE OR REPLACE PROCEDURE DeletarProduto(pIdProduto NUMBER) IS
	ProdutoConstraint EXCEPTION;
    StatusDesativado   EXCEPTION;
   
    PRAGMA EXCEPTION_INIT(ProdutoConstraint, -20001);
    PRAGMA EXCEPTION_INIT(StatusDesativado, -20002);
   
BEGIN
	FOR produto IN (SELECT Id, Status FROM Produto) LOOP
		FOR i IN (SELECT IdProduto FROM ProdutoPreco) LOOP

		IF pIdProduto = produto.Id AND produto.Status = 0 THEN
			RAISE StatusDesativado;
		ELSIF pIdProduto IN (i.IdProduto) THEN
			RAISE ProdutoConstraint;
		ELSE
    		DELETE FROM Produto WHERE Id = pIdProduto;
    	END IF;
    
    	END LOOP;
   	END LOOP;
    	
EXCEPTION
	WHEN StatusDesativado THEN
		DBMS_OUTPUT.PUT_LINE('Produto está desativado na tabela!');
		DBMS_OUTPUT.PUT_LINE('Código do erro: ' || SQLCODE);
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('Produto sendo utilizado na tabela ProdutoPreco!');
		DBMS_OUTPUT.PUT_LINE('Código do erro: ' || SQLCODE);
	
END;

CALL SYSTEM.DeletarProduto(1); -- Produto está desativado na tabela!
CALL SYSTEM.DeletarProduto(5); -- Produto sendo utilizado na tabela ProdutoPreco!
CALL SYSTEM.DeletarProduto(11); -- Produto deletado com sucesso

-- Exercício 7
CREATE OR REPLACE PROCEDURE ListarProdutoPrecoPorIdProduto(pIdProduto NUMBER, pOut OUT VARCHAR2) IS
	pValorSomado NUMBER;
   
BEGIN
	SELECT SUM(ProdutoPreco.Valor) INTO pValorSomado FROM Produto
		INNER JOIN ProdutoPreco ON Produto.Id = ProdutoPreco.IdProduto WHERE IdProduto = pIdProduto;
	pOut := 'Valor somado: ' || pValorSomado;

EXCEPTION
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('Produto inexistente!');
		DBMS_OUTPUT.PUT_LINE('Código do erro: ' || SQLCODE);

END;

DECLARE
	vOut VARCHAR2(200);
BEGIN
	ListarProdutoPrecoPorIdProduto(2, vOut);
	DBMS_OUTPUT.PUT_LINE(vOut);
END;