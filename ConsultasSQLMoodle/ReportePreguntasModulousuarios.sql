SELECT 
    u.id AS student_id,
CONCAT(u.firstname, ' ', u.lastname) As nombreCompleto,
  u.institution AS Institucion,
    u.department AS Maestria,
    u.city AS Campus,
    u.country AS Pais,
    q.name AS Modulo,
    qg.grade AS CalificacionModulo, -- Columna para la calificación del módulo
    SUBSTRING_INDEX(qq.questionsummary , ':', 1) AS PreguntaAsignadaAlAlumno,

    CASE
        WHEN SUBSTRING_INDEX(qq.rightanswer, ') ', -1) = SUBSTRING_INDEX(qq.responsesummary, ') ', -1)
        THEN 1
        ELSE 0
    END AS flagCorrect,
        SUBSTRING_INDEX(qq.rightanswer, ') ', -1) AS RespuestaCorrecta, -- Respuesta correcta
    SUBSTRING_INDEX(qq.responsesummary, ') ', -1) AS RespuestaDadaPorElUsuario, -- Respuesta dada por el usuario
     (SELECT 
         SUBSTRING_INDEX(qa.answer, ') ', -1) AS PosibleRespuesta
     FROM 
         prefix_question_answers qa
     WHERE 
         qa.question = qq.questionid
         AND SUBSTRING_INDEX(qa.answer, ') ', -1) <> SUBSTRING_INDEX(qq.responsesummary, ') ', -1)
     LIMIT 1
    ) AS Opcion1,
    (SELECT 
         SUBSTRING_INDEX(qa.answer, ') ', -1) AS PosibleRespuesta
     FROM 
         prefix_question_answers qa
     WHERE 
         qa.question = qq.questionid
         AND SUBSTRING_INDEX(qa.answer, ') ', -1) <> SUBSTRING_INDEX(Opcion1, ') ', -1)
     LIMIT 1
    ) AS Opcion2,
    (SELECT 
         SUBSTRING_INDEX(qa.answer, ') ', -1) AS PosibleRespuesta
     FROM 
         prefix_question_answers qa
     WHERE 
         qa.question = qq.questionid
         AND SUBSTRING_INDEX(qa.answer, ') ', -1) <> SUBSTRING_INDEX(Opcion1, ') ', -1)
         AND SUBSTRING_INDEX(qa.answer, ') ', -1) <> SUBSTRING_INDEX(Opcion2, ') ', -1)
     LIMIT 1
    ) AS Opcion3,
    (SELECT 
         SUBSTRING_INDEX(qa.answer, ') ', -1) AS PosibleRespuesta
     FROM 
         prefix_question_answers qa
     WHERE 
         qa.question = qq.questionid
         AND SUBSTRING_INDEX(qa.answer, ') ', -1) <> SUBSTRING_INDEX(Opcion1, ') ', -1)
         AND SUBSTRING_INDEX(qa.answer, ') ', -1) <> SUBSTRING_INDEX(Opcion2, ') ', -1)
         AND SUBSTRING_INDEX(qa.answer, ') ', -1) <> SUBSTRING_INDEX(Opcion3, ') ', -1)
     LIMIT 1
    ) AS Opcion4

FROM 
    prefix_user u
JOIN 
    prefix_user_enrolments ue ON u.id = ue.userid
JOIN 
    prefix_enrol e ON ue.enrolid = e.id
JOIN 
    prefix_course c ON e.courseid = c.id
JOIN 
    prefix_context cx ON c.id = cx.instanceid
JOIN 
    prefix_role_assignments ra ON u.id = ra.userid AND ra.contextid = cx.id
JOIN 
    prefix_role r ON ra.roleid = r.id
JOIN 
    prefix_quiz q ON c.id = q.course
JOIN 
    prefix_quiz_attempts qa ON q.id = qa.quiz AND u.id = qa.userid
JOIN 
    prefix_quiz_grades qg ON qg.quiz = q.id AND qg.userid = u.id -- Unir con la tabla de calificaciones del cuestionario
JOIN 
    prefix_question_usages qu ON qa.uniqueid = qu.id
JOIN 
    prefix_question_attempts qq ON qu.id = qq.questionusageid
JOIN 
    prefix_question_attempt_steps qas ON qq.id = qas.questionattemptid
JOIN
    prefix_question qd ON qq.questionid = qd.id -- Unir con la tabla de preguntas para obtener el questionTableId
JOIN 
    prefix_groups_members gm ON u.id = gm.userid
JOIN 
    prefix_groups g ON gm.groupid = g.id
WHERE 
    c.id = :course_id
    AND r.shortname = 'student_exam'
    AND qas.state = 'complete'
    AND g.name = :group_name
ORDER BY 
    u.lastname, u.firstname, q.name, qa.timefinish
