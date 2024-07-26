SELECT 
    u.id AS student_id,
    u.firstname AS student_name,
    q.name AS Modulo,
    qg.grade AS CalificacionModulo, -- Columna para la calificación del módulo
    qq.questionsummary AS PreguntaAsignadaAlAlumno,
    qq.questionid AS questionId, 
    qd.id AS questionTableId, -- Columna para el ID de la pregunta en la tabla mdl_question
    SUBSTRING_INDEX(qq.rightanswer, ') ', -1) AS RespuestaCorrecta, -- Respuesta correcta
    SUBSTRING_INDEX(qq.responsesummary, ') ', -1) AS RespuestaDadaPorElUsuario, -- Respuesta dada por el usuario
    CASE
        WHEN SUBSTRING_INDEX(qq.rightanswer, ') ', -1) = SUBSTRING_INDEX(qq.responsesummary, ') ', -1)
        THEN 1
        ELSE 0
    END AS RespuestaCorrecta,
    (SELECT 
         SUBSTRING_INDEX(qa.answer, ') ', -1) AS PosibleRespuesta
     FROM 
         mdl_question_answers qa
     WHERE 
         qa.question = qq.questionid
         AND SUBSTRING_INDEX(qa.answer, ') ', -1) <> SUBSTRING_INDEX(qq.rightanswer, ') ', -1)
         AND SUBSTRING_INDEX(qa.answer, ') ', -1) <> SUBSTRING_INDEX(qq.responsesummary, ') ', -1)
     LIMIT 1
    ) AS RespuestaNoElegida1,
    (SELECT 
         SUBSTRING_INDEX(qa.answer, ') ', -1) AS PosibleRespuesta
     FROM 
         mdl_question_answers qa
     WHERE 
         qa.question = qq.questionid
         AND SUBSTRING_INDEX(qa.answer, ') ', -1) <> SUBSTRING_INDEX(qq.rightanswer, ') ', -1)
         AND SUBSTRING_INDEX(qa.answer, ') ', -1) <> SUBSTRING_INDEX(qq.responsesummary, ') ', -1)
         AND SUBSTRING_INDEX(qa.answer, ') ', -1) <> SUBSTRING_INDEX(RespuestaNoElegida1, ') ', -1)
     LIMIT 1
    ) AS RespuestaNoElegida2,
    (SELECT 
         SUBSTRING_INDEX(qa.answer, ') ', -1) AS PosibleRespuesta
     FROM 
         mdl_question_answers qa
     WHERE 
         qa.question = qq.questionid
         AND SUBSTRING_INDEX(qa.answer, ') ', -1) <> SUBSTRING_INDEX(qq.rightanswer, ') ', -1)
         AND SUBSTRING_INDEX(qa.answer, ') ', -1) <> SUBSTRING_INDEX(qq.responsesummary, ') ', -1)
                  AND SUBSTRING_INDEX(qa.answer, ') ', -1) <> SUBSTRING_INDEX(RespuestaNoElegida1, ') ', -1)

         AND SUBSTRING_INDEX(qa.answer, ') ', -1) <> SUBSTRING_INDEX(RespuestaNoElegida2, ') ', -1)
     LIMIT 1
    ) AS RespuestaNoElegida3
FROM 
    mdl_user u
JOIN 
    mdl_user_enrolments ue ON u.id = ue.userid
JOIN 
    mdl_enrol e ON ue.enrolid = e.id
JOIN 
    mdl_course c ON e.courseid = c.id
JOIN 
    mdl_context cx ON c.id = cx.instanceid
JOIN 
    mdl_role_assignments ra ON u.id = ra.userid AND ra.contextid = cx.id
JOIN 
    mdl_role r ON ra.roleid = r.id
JOIN 
    mdl_quiz q ON c.id = q.course
JOIN 
    mdl_quiz_attempts qa ON q.id = qa.quiz AND u.id = qa.userid
JOIN 
    mdl_quiz_grades qg ON qg.quiz = q.id AND qg.userid = u.id -- Unir con la tabla de calificaciones del cuestionario
JOIN 
    mdl_question_usages qu ON qa.uniqueid = qu.id
JOIN 
    mdl_question_attempts qq ON qu.id = qq.questionusageid
JOIN 
    mdl_question_attempt_steps qas ON qq.id = qas.questionattemptid
JOIN
    mdl_question qd ON qq.questionid = qd.id -- Unir con la tabla de preguntas para obtener el questionTableId
WHERE 
    c.id = 3
    AND r.shortname = 'student_exam'
    AND qas.state = 'complete'
ORDER BY 
    u.lastname, u.firstname, q.name, qa.timefinish;
