SELECT 
    CONCAT(u.firstname, ' ', u.lastname) AS Nombre_Completo,
    u.email AS Email,
    u.phone1 AS Phone,
    u.institution AS Institucion,
    u.department AS Maestria,
    u.city AS Campus,
    u.country AS Pais,
    u.address AS Direccion,
    u.description AS Descripcion,
    c.fullname AS Examen,
    q.name AS Modulo,
    qa.id AS attempt_id,
    qa.sumgrades AS TotalRespuestaCorrectas,
    qa.timestart AS Hora_Inicio_date,
    qa.timefinish AS Hora_termino_date,
    TIMESTAMPDIFF(MINUTE, qa.timestart, qa.timefinish) AS Duracion_Minutos,
    qu.id AS question_usage_id,
    qq.id AS question_id,
    qq.slot AS OrdenEnQueAparecio,
qq.responsesummary AS RespuestaDadaPorElAlumno,

    qas.id AS answer_id,
    qas.state,
    qas.fraction,
    qst.name AS Pregunta,
 qst.questiontext AS TextoPregunta,
    qna.answer AS RespuestaCorrecta

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
    prefix_question_usages qu ON qa.uniqueid = qu.id
JOIN 
    prefix_question_attempts qq ON qu.id = qq.questionusageid
JOIN 
    prefix_question_attempt_steps qas ON qq.id = qas.questionattemptid
JOIN 
    prefix_question qst ON qq.questionid = qst.id
JOIN 
    prefix_question_attempt_step_data qasd ON qas.id = qasd.attemptstepid
JOIN 
    prefix_question_answers qna ON qst.id = qna.question AND qna.fraction = 1

WHERE 
    c.id = :course_id
    AND r.shortname = 'student'
    AND qas.state = 'complete'
ORDER BY 
    u.lastname, u.firstname, q.name, qa.timefinish
