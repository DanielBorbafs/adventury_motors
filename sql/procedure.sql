DROP PROCEDURE GerarConsultasAleatorias;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GerarConsultasAleatorias`(
    IN p_mes INT,
    IN p_ano INT,
    IN p_num_consultas INT
)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE v_id_paciente INT;
    DECLARE v_id_medico INT;
    DECLARE v_data_consulta DATE;
    DECLARE v_valor DECIMAL(10,2);
    DECLARE v_tipo_pagamento VARCHAR(20);
    DECLARE v_especialidade VARCHAR(30);
    
    -- Verifica se o mês é válido
    IF p_mes < 1 OR p_mes > 12 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Mês inválido. Deve ser entre 1 e 12';
    END IF;
    
    -- Verifica se existem pacientes e médicos cadastrados
    IF NOT EXISTS (SELECT 1 FROM PACIENTES LIMIT 1) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Nenhum paciente cadastrado na tabela PACIENTES';
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM MEDICOS LIMIT 1) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Nenhum médico cadastrado na tabela MEDICOS';
    END IF;
    
    -- Loop para gerar as consultas
    WHILE i < p_num_consultas DO
        -- Seleciona um paciente aleatório
        SELECT ID_PACIENTE INTO v_id_paciente FROM PACIENTES ORDER BY RAND() LIMIT 1;
        
        -- Seleciona um médico aleatório e obtém especialidade e valor
        SELECT ID_MEDICO, ESPECIALIDADE INTO v_id_medico, v_especialidade 
        FROM MEDICOS 
        ORDER BY RAND() 
        LIMIT 1;
        
        -- Define o valor baseado na especialidade
        SET v_valor = CASE 
            WHEN v_especialidade = 'Cardiologia' THEN 550.00
            WHEN v_especialidade = 'Pediatria' THEN 400.00
            WHEN v_especialidade = 'Ortopedia' THEN 500.00
            WHEN v_especialidade = 'Dermatologia' THEN 350.00
            ELSE 400.00 -- Clínico Geral
        END;
        
        -- Gera uma data aleatória no mês/ano especificado (considerando meses com 28, 30 ou 31 dias)
        SET v_data_consulta = CASE 
            WHEN p_mes IN (4, 6, 9, 11) THEN 
                CONCAT(p_ano, '-', LPAD(p_mes, 2, '0'), '-', LPAD(FLOOR(1 + RAND() * 30), 2, '0'))
            WHEN p_mes = 2 THEN 
                CONCAT(p_ano, '-', LPAD(p_mes, 2, '0'), '-', LPAD(FLOOR(1 + RAND() * 28), 2, '0'))
            ELSE 
                CONCAT(p_ano, '-', LPAD(p_mes, 2, '0'), '-', LPAD(FLOOR(1 + RAND() * 31), 2, '0'))
        END;
        
        -- Seleciona um tipo de pagamento aleatório
        SET v_tipo_pagamento = CASE FLOOR(1 + RAND() * 4)
            WHEN 1 THEN 'Cartão de Crédito'
            WHEN 2 THEN 'Dinheiro'
            WHEN 3 THEN 'PIX'
            ELSE 'Cartão de Débito'
        END;
        
        -- Insere a consulta
        INSERT INTO CONSULTAS (ID_PACIENTE, ID_MEDICO, DATA_CONSULTA, VALOR, STATUS, TIPO_PAGAMENTO)
        VALUES (v_id_paciente, v_id_medico, v_data_consulta, v_valor, 'Concluída', v_tipo_pagamento);
        
        SET i = i + 1;
    END WHILE;
    
    SELECT CONCAT(p_num_consultas, ' consultas geradas para ', LPAD(p_mes, 2, '0'), '/', p_ano) AS Resultado;
END