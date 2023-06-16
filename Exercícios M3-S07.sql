SELECT * FROM Produto;

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