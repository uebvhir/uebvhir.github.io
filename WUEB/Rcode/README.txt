Per a que es visualitzi l'index tant al menú esquerre com a l'inici del document cal: 

- Accedir al fitxer 
/home/NOMUSUARI/R/x86_64-pc-linux-gnu-library/3.5/rmdformats/templates/readthedown.html
E:\NNNNNNNNNX\AppData\Local\R\win-library\4.2\rmdformats\templates

- Canviar les següents línies  
<div id="main">
$body$
</div>

per: 

<div id="main">
$toc$
$body$
</div>


És a dir, afegir el $toc$. 


(Una altre opció a data 28.03.2019 és substituir directament l'arxiu per el que es troba en aquesta carpeta: "readthedown.html")



Per als colors, cal substituir a l'arxiu readthedown.css  a \rmdformats\templates\readthedown
tots els  #9F2042 per #993489


Per modificar l'ample de l'informe es pot modificar a l'arxiu readthedown.css dins del paquet (p.e /4.0/rmdformats/templates)

Linia 161 modificar  
max-width:900px;      
per   
max-width:1100px;

#content{
    background:#fcfcfc;
    height:100%;
    margin-left:300px;
    /* margin:auto; */
    max-width:1100px;
    min-height:100%;
}
