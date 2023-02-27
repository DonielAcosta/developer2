SELECT
    p.zona,
    p.nomzona,
    round(p.meta_m + p.meta_c + p.meta_o, 0) AS META,
        p.und_m AS MERIDA,
        p.und_c AS CENTRO,
        p.und_o AS ORIENTE,
    round(p.und_m + p.und_c + p.und_o, 2) AS TUNIDADES,
    round(p.vtotal_m + p.vtotal_c + p.vtotal_o,2) AS Ventas,
    round(p.vtotali_m + p.vtotali_c + p.vtotali_o,2) AS Ventas_Iva
FROM sfac r
LEFT JOIN (
	SELECT
        aa.zona,
        aa.nomzona,
        IF (aa.meta         IS NULL,0,aa.meta) meta_m,
        IF (bb.meta         IS NULL,0,bb.meta) meta_c,
        IF (cc.meta         IS NULL,0,cc.meta) meta_o,
        IF (SUM(aa.unidad)  IS NULL,0,SUM(aa.unidad)) und_m,
        IF (SUM(aa.vtotal)  IS NULL,0,SUM(aa.vtotal)) vtotal_m,
        IF (SUM(aa.vtotali) IS NULL,0,SUM(aa.vtotali)) vtotali_m,
        IF (SUM(bb.unidad)  IS NULL,0,SUM(bb.unidad)) und_c,
        IF (SUM(bb.vtotal)  IS NULL,0,SUM(bb.vtotal)) vtotal_c,
        IF (SUM(bb.vtotali) IS NULL,0,SUM(bb.vtotali)) vtotali_c,
        IF (SUM(cc.unidad)  IS NULL,0,SUM(cc.unidad)) und_o,
        IF (SUM(cc.vtotal)  IS NULL,0,SUM(cc.vtotal)) vtotal_o,
        IF (SUM(cc.vtotali) IS NULL,0,SUM(cc.vtotali)) vtotali_o
   FROM(
		SELECT
			c.zona,
			g.nombre nomzona,
            m.cantidad as meta,
		    SUM(IF (a.tipo_doc = 'F', 1 ,- 1) * e.cana) AS unidad,
			sum(e.tota *IF (a.tipo_doc = 'F', 1 ,- 1) * (a.tipo_doc != 'X')) vtotal,
			sum(round(e.tota *(100 + e.iva) / 100, 2) *IF (a.tipo_doc = 'F', 1 ,- 1) * (a.tipo_doc != 'X')) vtotali
		FROM
            datasis.sfac a
            LEFT JOIN datasis.scli AS c ON a.cod_cli = c.cliente
            LEFT JOIN datasis.sitems AS e ON e.transac = a.transac	AND e.tipoa = a.tipo_doc
            LEFT JOIN datasis.zona AS g ON c.zona = g.codigo
            LEFT JOIN datasis.metzona AS m ON g.codigo = m.zona 
		WHERE
            a.referen <> 'P'
            AND a.tipo_doc <> 'X'
            AND a.fecha >= 20221101
            AND a.fecha <= 20221108
            AND m.mes = DATE_FORMAT('20221101', '%Y%m')
        GROUP BY
            a.zona
        ORDER BY
            c.zona
	) AS aa
    LEFT JOIN (
        SELECT
            c.zona,
            g.nombre nomzona,
            m.cantidad as meta,
            SUM(IF (a.tipo_doc = 'F', 1 ,- 1) * e.cana) AS unidad,
            sum(e.tota *IF (a.tipo_doc = 'F', 1 ,- 1) * (a.tipo_doc != 'X')) vtotal,
            sum(round(e.tota *(100 + e.iva) / 100, 2) *IF (a.tipo_doc = 'F', 1 ,- 1) * (a.tipo_doc != 'X')) vtotali
        FROM
            centro.sfac a
            LEFT JOIN centro.scli AS c ON a.cod_cli = c.cliente
            LEFT JOIN centro.sitems AS e ON e.transac = a.transac	AND e.tipoa = a.tipo_doc
            LEFT JOIN centro.zona AS g ON c.zona = g.codigo
            LEFT JOIN centro.metzona AS m ON g.codigo = m.zona 
        WHERE
            a.referen <> 'P'
            AND a.tipo_doc <> 'X'
            AND a.fecha >= 20221101
            AND a.fecha <= 20221108
            AND m.mes = DATE_FORMAT('20221101', '%Y%m')
        GROUP BY
            a.zona
        ORDER BY
            c.zona
    ) AS bb ON aa.zona = bb.zona
    LEFT JOIN (
        SELECT
            c.zona,
            g.nombre nomzona,
            m.cantidad as meta,
            SUM(IF (a.tipo_doc = 'F', 1 ,- 1) * e.cana) AS unidad,
            sum(e.tota *IF (a.tipo_doc = 'F', 1 ,- 1) * (a.tipo_doc != 'X')) vtotal,
            sum(round(e.tota *(100 + e.iva) / 100, 2) *IF (a.tipo_doc = 'F', 1 ,- 1) * (a.tipo_doc != 'X')) vtotali
        FROM
            oriente.sfac a
            LEFT JOIN oriente.scli AS c ON a.cod_cli = c.cliente
            LEFT JOIN oriente.sitems AS e ON e.transac = a.transac AND e.tipoa = a.tipo_doc
            LEFT JOIN oriente.zona AS g ON c.zona = g.codigo
            LEFT JOIN oriente.metzona AS m ON g.codigo = m.zona 
        WHERE
            a.referen <> 'P'
            AND a.tipo_doc <> 'X'
            AND a.fecha >= 20221101
            AND a.fecha <= 20221108
            AND m.mes = DATE_FORMAT('20221101', '%Y%m')
        GROUP BY
            a.zona
        ORDER BY
            c.zona
    ) AS cc ON aa.zona = cc.zona
    GROUP BY
        aa.nomzona
) p ON r.zona = p.zona
WHERE
	p.zona IS NOT NULL
GROUP BY
	p.nomzona

/* principal*/
SELECT
	p.zona,
	p.nomzona,
  round(p.meta_m + p.meta_c + p.meta_o, 0) AS META,
	p.und_m AS MERIDA,
	p.und_c AS CENTRO,
	p.und_o AS ORIENTE,
	round(p.und_m + p.und_c + p.und_o, 2) AS TUNIDADES,
	round(p.vtotal_m + p.vtotal_c + p.vtotal_o,2) AS Ventas,
	round(p.vtotali_m + p.vtotali_c + p.vtotali_o,2) AS Ventas_Iva
FROM
	sfac r
LEFT JOIN (
	SELECT
		aa.zona,
		aa.nomzona,
   IF (
		aa.meta IS NULL,
		0,
		aa.meta
	) meta_m,

   IF (
		bb.meta IS NULL,
		0,
		bb.meta
	) meta_c,

  IF (
		cc.meta IS NULL,
		0,
		cc.meta
	) meta_o,


	IF (
		SUM(aa.unidad) IS NULL,
		0,
		SUM(aa.unidad)
	) und_m,

IF (
	SUM(aa.vtotal) IS NULL,
	0,
	SUM(aa.vtotal)
) vtotal_m,

IF (
	SUM(aa.vtotali) IS NULL,
	0,
	SUM(aa.vtotali)
) vtotali_m,

IF (
	SUM(bb.unidad) IS NULL,
	0,
	SUM(bb.unidad)
) und_c,

IF (
	SUM(bb.vtotal) IS NULL,
	0,
	SUM(bb.vtotal)
) vtotal_c,

IF (
	SUM(bb.vtotali) IS NULL,
	0,
	SUM(bb.vtotali)
) vtotali_c,

IF (
	SUM(cc.unidad) IS NULL,
	0,
	SUM(cc.unidad)
) und_o,

IF (
	SUM(cc.vtotal) IS NULL,
	0,
	SUM(cc.vtotal)
) vtotal_o,

IF (
	SUM(cc.vtotali) IS NULL,
	0,
	SUM(cc.vtotali)
) vtotali_o
FROM
	(
		SELECT
			c.zona,
			g.nombre nomzona,
      m.cantidad as meta,
			SUM(
				IF (a.tipo_doc = 'F', 1 ,- 1) * e.cana
			) AS unidad,
			sum(
				e.tota *
				IF (a.tipo_doc = 'F', 1 ,- 1) * (a.tipo_doc != 'X')
			) vtotal,
			sum(
				round(e.tota *(100 + e.iva) / 100, 2) *
				IF (a.tipo_doc = 'F', 1 ,- 1) * (a.tipo_doc != 'X')
			) vtotali
		FROM
			datasis.sfac a
		LEFT JOIN datasis.scli AS c ON a.cod_cli = c.cliente
		LEFT JOIN datasis.sitems AS e ON e.transac = a.transac	AND e.tipoa = a.tipo_doc
		LEFT JOIN datasis.vend AS g ON c.zona = g.codigo
    LEFT JOIN datasis.sclime AS m ON g.codigo = m.zona 
		WHERE
			a.referen <> 'P'
		AND a.tipo_doc <> 'X'
		AND a.fecha >= 20230201
		AND a.fecha <= 20230224
    AND m.mes = DATE_FORMAT('20230201', '%Y%m')
   	GROUP BY
			a.zona
		ORDER BY
			c.zona
	) AS aa
LEFT JOIN (
	SELECT
		c.zona,
		g.nombre nomzona,
    m.cantidad as meta,
		SUM(

			IF (a.tipo_doc = 'F', 1 ,- 1) * e.cana
		) AS unidad,
		sum(
			e.tota *
			IF (a.tipo_doc = 'F', 1 ,- 1) * (a.tipo_doc != 'X')
		) vtotal,
		sum(
			round(e.tota *(100 + e.iva) / 100, 2) *
			IF (a.tipo_doc = 'F', 1 ,- 1) * (a.tipo_doc != 'X')
		) vtotali
	FROM
		centro.sfac a
	LEFT JOIN centro.scli AS c ON a.cod_cli = c.cliente
	LEFT JOIN centro.sitems AS e ON e.transac = a.transac	AND e.tipoa = a.tipo_doc
	LEFT JOIN centro.zona AS g ON c.zona = g.codigo
  LEFT JOIN centro.metzona AS m ON g.codigo = m.zona 
  WHERE
		a.referen <> 'P'
	AND a.tipo_doc <> 'X'
	AND a.fecha >= 20230201
	AND a.fecha <= 20230224
  AND m.mes = DATE_FORMAT('20230201', '%Y%m')
	GROUP BY
		a.zona
	ORDER BY
		c.zona
) AS bb ON aa.zona = bb.zona
LEFT JOIN (
	SELECT
		c.zona,
		g.nombre nomzona,
    m.cantidad as meta,
		SUM(

			IF (a.tipo_doc = 'F', 1 ,- 1) * e.cana
		) AS unidad,
		sum(
			e.tota *
			IF (a.tipo_doc = 'F', 1 ,- 1) * (a.tipo_doc != 'X')
		) vtotal,
		sum(
			round(e.tota *(100 + e.iva) / 100, 2) *
			IF (a.tipo_doc = 'F', 1 ,- 1) * (a.tipo_doc != 'X')
		) vtotali
	FROM
		oriente.sfac a
	LEFT JOIN oriente.scli AS c ON a.cod_cli = c.cliente
	LEFT JOIN oriente.sitems AS e ON e.transac = a.transac AND e.tipoa = a.tipo_doc
	LEFT JOIN oriente.zona AS g ON c.zona = g.codigo
  LEFT JOIN oriente.metzona AS m ON g.codigo = m.zona 
	WHERE
		a.referen <> 'P'
	AND a.tipo_doc <> 'X'
		AND a.fecha >= 20230201
	AND a.fecha <= 20230224
  AND m.mes = DATE_FORMAT('20230201', '%Y%m')
	GROUP BY
		a.zona
	ORDER BY
		c.zona
) AS cc ON aa.zona = cc.zona
GROUP BY
	aa.nomzona
) p ON r.zona = p.zona
WHERE
	p.zona IS NOT NULL
GROUP BY
	p.nomzona