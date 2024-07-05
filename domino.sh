!/bin/bash
#===========================================
#CONSTANTES #===============================
#===========================================
MENU_TEXT="\n\t\e[1;97mM) MODIFICAR CONFIGURACIÓN \e[40m\e[0;32m\n\t\e[1;97mJ) JUGAR \e[4m\e[0;32m\n\t\e[1;97mF) CLASIFICACIÓN
\e[40m\e[0;32m\n\t\e[1;97mE) ESTADISTICA\e[40m\e[0;32m\n\t\e[1;97mS) SALIR \e[40m\e[0;32m\n"
MENU_CFG="\n\t\e[1;97mJ) MODIFICAR JUGADORES \e[40m\e[0;32m\n\t\e[1;97mP) MODIFICAR PUNTOS GANADOR \e[40m\e[0;32m\n\t\e[1;97mI) MODIFICAR INTELIGENCIA \e[40m\e[0;32m\n\t\e[1;97mL) MODIFICAR
FICHERO
LOG \e[40m\e[0;32m\n\t\e[1;97mI) SALIR \e[40m\e[0;32m\n"
#Minima y maxima jugadores permitidos
MIN_JUG=2
MAX_JUG=4
MIN_PUNT=50
MAX_PUNT=100
#Ruta del fichero de config.cfg (directorio actual)
CONFIG_FILE="config.cfg"
#(vacio porque no lo hemos leido de config.cfg)
FICHERO_LOG=""
#Comparacion para ver si hay letras en una variable
COMP="^[0-9]+$"
#FUNCIONES AUX
#============
#TITULO======
#============
function TITULO {
 echo -e "\e[1;97m EL DOMINO \e[40m\e[0;32m"
}
#=========================
#PULSA PARA CONTINUAR=====
#=========================
function PULSE_PARA_CONTINUAR
 {
 echo "Pulse INTRO para continuar."
 read
 echo "\n"
 }
#=======================
#COMPONENTES GRUPO======
#=======================
function DATOS_GRUPO
 {
 echo -n -e "\n\t\e[1;92m SISTEMAS OPERATIVOS I \e[40m\e[0;32m\n\n\t\e[1;92m TRABAJO REALIZADO POR: MARCOS RIVAS KYOGURO E IKER PEREZ VICENTE
grupo PB2\e[40m\e[0;32m\n"
 exit 0
 }
#==============
#TO UPPER======
#==============

function OPCION_TO_UPPER
 {
 case $OPCION in
 "j") OPCION="J"
 ;;
 "c") OPCION="C"
 ;;
 "e") OPCION="E"
 ;;
 "g") OPCION="G"
 ;;
 "s") OPCION="S"
 ;;
 "p") OPCION="P"
 ;;
 "i") OPCION="I"
 ;;
 "l") OPCION="L"
 ;;
 esac
}
#==========================================
#BORRAR TODOS LOS FICHEROS TEMPORALES======
#==========================================
function BORRAR_FICHEROS_TEMPORALES
{
 if test -f FDESORDEN
 then
 rm FDESORDEN
 fi
 if test -f FDESORDEN2.0
 then
 rm FDESORDEN2.0
 fi
 if test -f FDESORDEN2.1
 then
 rm FDESORDEN2.1
 fi
 if test -f FDESORDEN2.1
 then
 rm FDESORDEN2.1
 fi
 if test -f FDESORDEN2.2
 then
 rm FDESORDEN2.2
 fi
 if test -f FDESORDEN2.3
 then
 rm FDESORDEN2.3
 fi

 if test -f fichasJUG
 then
 rm fichasJUG
 fi
 if test -f fichasPC1
 then
 rm fichasPC1
 fi
 if test -f fichasPC2
 then
 rm fichasPC2
 fi

 if test -f fichasPC3
 then
 rm fichasPC3
 fi
 if test -f POZO
 then
 rm POZO
 fi
 if test -f FORDEN
 then
 rm FORDEN
 fi
}

#===============================
#CARGA DE LA CONFIGURACION======
#===============================

function CARGAR_CONFIG {
 #COmprobamos que el fichero configuracion existe y tenemos permisos.
 if test -r $CONFIG_FILE
 then #si podemos leer
 FLAG=false
 JUG=$(grep "^JUGADORES=" < $CONFIG_FILE |cut -f 2 -d "="| tr -d "\r" )
 PUN=$(grep "^PUNTOSGANADOR=" < $CONFIG_FILE |cut -f 2 -d "="| tr -d "\r" )
 INT=$(grep "^INTELIGENCIA=" < $CONFIG_FILE |cut -f 2 -d "="| tr -d "\r" )
 LOG=$(grep "^LOG=" < $CONFIG_FILE |cut -f 2 -d "=" )
 else #si no podemos leer, error es TRUE
 FLAG=true
 echo "ERROR: no se encontro el fichero config.cfg o no se tienen permisos de necesarios"
 fi
 if ! [[ -r $LOG ]] || ! [[ -w $LOG ]] && [[ -a $LOG ]]
 then
 FLAG=true
 echo "ERROR: no se encontro el fichero $CONFIG_FILE o no se tienen permisos necesarios."
 fi

 #Condiciones secundarias

 # Comprobamos que los jugadores son solo grupos de 2 a 4
 if test $FLAG = false
 then
 if [[ $JUG -lt $MIN_JUG ]] || [[ $JUG -gt $MAX_JUG ]]
 then
 FLAG=true
echo "El numero de jugadores debe de ser de entre 2 a 4: Jugadores--> $JUG"
 fi
 if [[ $PUN -lt $MIN_PUNT ]] || [[ $PUN -ge $MAX_PUNT ]]
 then
 FLAG=true
echo "El objetivo de puntos debe de ser de entre 50,incluido, a 100, no incluido: PUNTOS GANADOR--> $PUN"
 fi

 if test $INT -eq 0
 then
 FLAG=true
echo "Los jugadores no interactivos que intervienen en la partida eligen sus fichas de manera aleatoria"
 else if test $INT -eq 1
 then
 FLAG=true
 echo "Los jugadores no interactivos que intervienen en la partida eligen sus fichas de acuerdo a una estrategia ganadora"
 fi

 fi
 fi
 }
#=======================
#CAMBIAR JUGADORES======
#=======================

function CAMBIAR_JUGADORES
 {
 echo -e -n "\n\e[1;97mIntroduzca el nuevo número de jugadores (2-4) >> \e[0m"
 read JUG_TEMP
 #Comprobamos que solo son numeros
 if ! [[ $JUG_TEMP =~ $COMP ]];
 then
 echo -e "\n\e[1;31mERROR: solo son validos numeros, el uso de otro tipo de caracteres esta restringido\e[0m"
 PULSE_PARA_CONTINUAR
 #comprobamos que los valores esten en el rango permitido
 elif [[ $JUG_TEMP -lt $MIN_JUG ]] || [[ $JUG_TEMP -gt $MAX_JUG ]]
 then
 echo -e "\n\e[1;31mERROR: Introduzca un numero en el rango ($MIN_JUG-$MAX_JUG)\e[0m"
 PULSE_PARA_CONTINUAR
 else
 JUG=$JUG_TEMP
 echo -e "JUGADORES=$JUG\nPUNTOSGANADOR=$PUN\nINTELIGENCIA=$INT\nLOG=$LOG" > $CONFIG_FILE
 fi
 }

#=======================
#CAMBIAR PUNTOS=========
#=======================

function CAMBIAR_PUNTOS
 {
 echo -e -n "\n\e[1;97mIntroduzca el nuevo número de puntos ganadores (50-100) >> \e[0m"
 read PUN_TEMP
 #Comprobamos que solo son numeros
 if ! [[ $PUN_TEMP =~ $COMP ]]
 then
 echo -e "\n\e[1;31mERROR: solo son validos numeros, el uso de otro tipo de caracteres esta restringido\e[0m"
 PULSE_PARA_CONTINUAR
 #comprobamos que los valores esten en el rango permitido
 elif [[ $PUN_TEMP -lt 50 ]] || [[ $PUN_TEMP -gt 100 ]]
 then
 echo -e "\n\e[1;31mERROR: Introduzca un numero en el rango (50-100)\e[0m"
 PULSE_PARA_CONTINUAR
 else
 PUN=$PUN_TEMP
 echo -e "JUGADORES=$JUG\nPUNTOSGANADOR=$PUN\nINTELIGENCIA=$INT\nLOG=$LOG" > $CONFIG_FILE

 fi
 }
#=======================
#CAMBIAR INTELIGENCIA===
#=======================


function CAMBIAR_INTELIGENCIA
 {
 echo -e -n "\n\e[1;97mIntroduzca la nueva dificultad de la IA (0-1) >> \e[0m"
 read INT_TEMP
 #Comprobamos que solo son numeros
 if ! [[ $INT_TEMP =~ $COMP ]];
 then
 echo -e "\n\e[1;31mERROR: solo son validos numeros, el uso de otro tipo de caracteres esta restringido\e[0m"
 PULSE_PARA_CONTINUAR
 #comprobamos que los valores esten en el rango permitido
 elif test $INT_TEMP -lt 0 -o $INT_TEMP -gt 1
 then
 echo -e "\n\e[1;31mERROR: Introduzca un numero en el rango (0-1)\e[0m"
 PULSE_PARA_CONTINUAR
 else
 INT=$INT_TEMP
 echo -e "JUGADORES=$JUG\nPUNTOSGANADOR=$PUN\nINTELIGENCIA=$INT\nLOG=$LOG" > $CONFIG_FILE
 fi
 }

#=========================
#CAMBIAR FICHERO LOG======
#=========================

function CAMBIAR_LOG
 {
 echo -e -n "\n\e[1;97mIntroduzca la nueva ruta de LOG >> \e[0m"
 read NEW_FICHERO_LOG
 NEW_FICHERO_LOG_PATH=$(dirname $NEW_FICHERO_LOG)
 if ! [[ -d $NEW_FICHERO_LOG ]];
 then
 echo -e "\n\e[1;31mERROR: No se encontro la ruta o no se tienen los permisos\e[0m"
 PULSE_PARA_CONTINUAR
 elif ! [[ $NEW_FICHERO_LOG =~ ".txt" ]]
 then
 echo -e "\n\e[1;31mERROR: No ha introducido un archivo con extension .txt\e[0m"
 PULSE_PARA_CONTINUAR
 elif ! [[ -r $NEW_FICHERO_LOG ]] || ! [[ -w $NEW_FICHERO_LOG ]] && [[ -a $NEW_FICHERO_LOG ]];
 then
 echo -e "\n\e[1;31mERROR: No se tienen los permisos necesarios sobre $NEW_FICHERO_LOG \e[0m"
 PULSE_PARA_CONTINUAR
 else
 LOG=$NEW_FICHERO_LOG
 echo -e "JUGADORES=$JUG\nPUNTOSGANADOR=$PUN\nINTELIGENCIA=$INT\nLOG=$LOG" > $CONFIG_FILE
 fi
 }


#=======================
#CONFIGURACION==========
#=======================


function CONFIG
 {
 EXIT_CFG=false

 #SE PIDE LA INTRODUCCION DE UN VALOR Y SE ACTUA EN CONSECUENCIA
 until test $EXIT_CFG = true
 do
 #ESCRIBIMOS EL MENU
 clear
 TITULO
 echo -e "\n\n\t>JUGADORES: \e[1;41;97m$JUG\e[40m\e[0m"
 echo -e "\n\t\e[1;96m>PUNTOS GANADOR: \e[1;41;97m$PUN\e[40m\e[0;32m"
 echo -e "\n\n\t>INTELIGENCIA: \e[1;41;97m$INT\e[40m\e[0m"
 echo -e "\n\t\e[1;96m>FICHERO LOG: \e[1;41;97m$LOG\e[40m\e[0;32m"

 echo -e $MENU_CFG
 echo -n -e "\e[1;94mIntroduzca una opcion >> "
 read OPCION_CFG
 OPCION_TO_UPPER
 case $OPCION_CFG in
 "J") #MODIFICAR JUGADORES
 CAMBIAR_JUGADORES
 ;;
 "P") #MODIFICAR PUNTOS:
 CAMBIAR_PUNTOS
;;
 "I") #MODIFICAR INTELIGENCIA
 CAMBIAR_INTELIGENCIA
;;
 "L") #MODIFICAR FICHERO LOG
 CAMBIAR_LOG
 ;;
 "S") #SALIR

 EXIT_CFG=true
;;

 *)#default
 echo -e -n "\n\e[1;31mERROR: Introduzca un caracter valido\e[0m"
 PULSE_PARA_CONTINUAR
;;
 esac
 done
 }

#==========================
#CLASIFICACION=============
#==========================


function CLASIFICACION
 {

 #EN EL CASO DE QUE HAYA PARTIDAS JUGADAS HAREMOS LOS CALCULOS

 if ! [[ -s $LOG ]] || ! [[ -r $LOG ]] ;
 then
 echo -e -n "\nNo se tienen registros de fichero.log todavia"
 else

 #CALCULO EL NUMERO DE PARTIDAS JUGADAS
 PAR_JUGADAS=$(wc -l < $LOG)

 #PONEMOS A 0 LAS MEDIAS DE TIEMPO Y PUNTOS

 T_INVERTIDO=0
 P_OBTENIDOS=0

 P_CORTA=$(head -1 $LOG | cut -f 4 -d "|" )
 P_CORTA_L=$(head -1 $LOG)
 P_LARGA=$(head -1 $LOG | cut -f 4 -d "|" )
 P_LARGA_L=$(head -1 $LOG)

 P_MAS_RONDAS=$(head -1 $LOG | cut -f 5 -d "|" )
 P_MAS_RONDAS_L=$(head -1 $LOG)

 P_MENOS_RONDAS=$(head -1 $LOG | cut -f 5 -d "|" )
 P_MENOS_RONDAS_L=$(head -1 $LOG)

 P_MAX_PUNTOSG=$(head -1 $LOG | cut -f 7 -d "|" )
 P_MAX_PUNTOSG_L=$(head -1 $LOG)


 PUNTOS1=$( head -1 $LOG | cut -f 9 -d "|" | cut -f 1 -d "-")
 PUNTOS2=$( head -1 $LOG | cut -f 9 -d "|" | cut -f 2 -d "-")
 PUNTOS3=$( head -1 $LOG | cut -f 9 -d "|" | cut -f 3 -d "-" | tr "*" "0")
 PUNTOS4=$( head -1 $LOG | cut -f 9 -d "|" | cut -f 4 -d "-" | tr "*" "0")

 P_MAX_PUNTOS_TOTALES=$(($PUNTOS1+$(($PUNTOS2+$(($PUNTOS3+$PUNTOS4))))))
 P_MAX_PUNTOS_TOTALES_L=$(head -1 $LOG)

 for line in $(cat $LOG)
 do


 TIEMPO=$( echo $line | cut -f 4 -d "|")
 ROND=$( echo $line | cut -f 5 -d "|")
 INTELIGENCIA=$( echo $line | cut -f 6 -d "|")
 PUNTOSGANADOR=$( echo $line | cut -f 7 -d "|")

 PUNTOS1=$( echo $line | cut -f 9 -d "|" | cut -f 1 -d "-")
 PUNTOS2=$( echo $line | cut -f 9 -d "|" | cut -f 2 -d "-")
 PUNTOS3=$( echo $line | cut -f 9 -d "|" | cut -f 3 -d "-"| tr "*" "0")
 PUNTOS4=$( echo $line | cut -f 9 -d "|" | cut -f 4 -d "-"| tr "*" "0")

 PUNTOS=$PUNTOS1+$PUNTOS2+$PUNTOS3+$PUNTOS4

 T_INVERTIDO=$(($T_INVERTIDO+$TIEMPO))
 P_OBTENIDOS=$(($P_OBTENIDOS+$PUNTOS))

 #PARTIDA MÁS CORTA

 if test $TIEMPO -lt $P_CORTA
then
 P_CORTA=$TIEMPO
 P_CORTAL=$line
 fi
 #PARTIDA MÁS LARGA
 if test $TIEMPO -gt $P_LARGA
 then
 P_LARGA=$TIEMPO
P_LARGA_L=$line
 fi

 #PARTIDA CON MÁS RONDAS

 if test $ROND -gt $P_MAS_RONDAS
then
 P_MAS_RONDAS=$ROND
P_MAS_RONDAS_L=$line
 fi
 #PARTIDA CON MENOS RONDAS
 if test $ROND -lt $P_MENOS_RONDAS
 then
 P_MENOS_RONDAS=$ROND
P_MENOS_RONDAS_L=$line
 fi

 #PARTIDA CON MAXIMO PUNTOS GANADOR

 if test $PUNTOSGANADOR -gt $P_MAX_PUNTOSG
 then
 P_MAX_PUNTOSG=$PUNTOSGANADOR
P_MAX_PUNTOSG_L=$line
 fi

 #PARTIDA CON MAS PUNTOS OBTENIDOS POR TODOS LOS JUGADORES
 if test $PUNTOS -gt $P_MAX_PUNTOS_TOTALES
then
 P_MAX_PUNTOS_TOTALES=$PUNTOS
 P_MAX_PUNTOS_TOTALES_L=$line
 fi

 done

 echo -e "\nCLASIFICACION: \n"

 echo -e "\n\tPartida mas corta >> \e[1;41m$P_CORTA \e[0;1;97m \n\t\t>> $P_CORTA_L "
 echo -e "\n\tPartida mas larga >> \e[1;41m$P_LARGA \e[0;1;97m \n\t\t>> $P_LARGA_L "
 echo -e "\n\tPartida con mas rondas >> \e[1;41m$P_MAS_RONDAS \e[0;1;97m \n\t\t>> $P_MAS_RONDAS_L "
 echo -e "\n\tPartida con menos rondas >> \e[1;41m$P_MENOS_RONDAS \e[0;1;97m \n\t\t>> $P_MENOS_RONDAS_L "
 echo -e "\n\tPartida con maximo Puntos Ganadores >> \e[1;41m$P_MAX_PUNTOSG \e[0;1;97m \n\t\t>> $P_MAX_PUNTOSG_L "
 echo -e "\n\tPartida con mas puntos obtenidos por los jugadores >> \e[1;41m$P_MAX_PUNTOS_TOTALES \e[0;1;97m \n\t\t>> $P_MAX_PUNTOS_TOTALES_L "


 fi

 }

#==========================
#ESTADISTICA===============
#==========================

function ESTADISTICA
{



 if ! [[ -s $LOG ]] || ! [[ -r $LOG ]]
 then
 echo -e -n "\nNo se tienen registros de fichero.log todavia"
 else

 #CALCULO EL NUMERO DE PARTIDAS JUGADAS

 PAR_JUGADAS=$(wc -l < $LOG)

 #PONEMOS A 0 LAS MEDIAS DE TIEMPO Y PUNTOS

 T_INVERTIDO=0
 P_OBTENIDOS=0
 P_CONINTELIGENCIA=0
 P_GANADORES=0
 R_INVERTIDAS=0

 PUNTOS1=$( head -1 $LOG | cut -f 9 -d "|" | cut -f 1 -d "-")
 PUNTOS2=$( head -1 $LOG | cut -f 9 -d "|" | cut -f 2 -d "-")
 PUNTOS3=$( head -1 $LOG | cut -f 9 -d "|" | cut -f 3 -d "-" | tr "*" "0")
 PUNTOS4=$( head -1 $LOG | cut -f 9 -d "|" | cut -f 4 -d "-" | tr "*" "0")



 for line in $(cat $LOG)
 do


 TIEMPO=$( echo $line | cut -f 4 -d "|")
 ROND=$( echo $line | cut -f 5 -d "|")
 INTELIG=$( echo $line | cut -f 6 -d "|")
 PUNTOSG=$( echo $line | cut -f 7 -d "|")
 JUGADORG=$( echo $line | cut -f 8 -d "|")

 PUNTOS1=$( echo $line | cut -f 9 -d "|" | cut -f 1 -d "-")
 PUNTOS2=$( echo $line | cut -f 9 -d "|" | cut -f 2 -d "-")
 PUNTOS3=$( echo $line | cut -f 9 -d "|" | cut -f 3 -d "-"| tr "*" "0")
 PUNTOS4=$( echo $line | cut -f 9 -d "|" | cut -f 4 -d "-"| tr "*" "0")

 PUNTOS_TOTALES=$(($PUNTOS_TOTALES+$(($PUNTOS1+$(($PUNTOS2+$(($PUNTOS3+$PUNTOS4))))))))

 T_INVERTIDO=$(($T_INVERTIDO+$TIEMPO))
 P_GANADORES=$(($P_GANADORES+$PUNTOSG))
 R_INVERTIDAS=$(($R_INVERTIDAS+$ROND))

 if [[ $INTELIG -eq 1 ]]
 then

 P_CONINTELIGENCIA=$(($P_CONINTELIGENCIA+1))

 fi


 done
#Hallamos las medias de longitudes y tiempos

 M_PUNTOSGANADORES=$(($P_GANADORES/$PAR_JUGADAS))
 M_RONDAS=$(( $R_INVERTIDAS/$PAR_JUGADAS ))
 M_TIEMPO=$(( $T_INVERTIDO/$PAR_JUGADAS ))
 P_PARTIDA_IA=$(($P_CONINTELIGENCIA/$PAR_JUGADAS*100))
 M_PUNTOSTOTALES=$(($PUNTOS_TOTALES/$PAR_JUGADAS))



#Sacamos las estadisticas

 echo -e "\nESTADISTICAS"
 echo -e "\n\tNumero de partidas jugadas >> $PAR_JUGADAS "
 echo -e "\n\tMedia de puntos ganadores >> $M_PUNTOSGANADORES "
 echo -e "\n\tMedia de rondas de las partidas jugadas. >> $M_RONDAS"
 echo -e "\n\tMedia de los tiempos de todas las partidas jugadas >> $M_TIEMPO "
 echo -e "\n\tTiempo total invertido en todas las partidas>> $T_INVERTIDO "
 echo -e "\n\tPorcentaje de partidas jugadas con inteligencia activada >> $P_PARTIDA_IA "
 echo -e "\n\tMedia de la suma de los puntos obtenidos por todos los jugadores en las partidas jugadas >> $M_PUNTOSTOTALES"


 fi



}


#=================================
#DESORDENAR FICHERO ORDENADO======
#=================================

function DESORDENAR
{

rm FDESORDEN
python -c "import random, sys; x = open(sys.argv[1]).readlines(); random.shuffle(x); print ''.join(x)," FORDEN>>FDESORDEN

}
#=======================
#CREAR FICHA DEL JUEGO==
#=======================
CREAR_FICHA()
{

declare -a FICHA

FICHA[0]=$1
FICHA[1]=$2


echo "${FICHA[0]} | ${FICHA[1]}">>FORDEN

}


#=======================
#ASIGNAR FICHAS ORDEN===
#=======================

function ASIG_FICHA()
{

i=0
j=0
cont=1
rm FORDEN

while test $i -le 6
do
 while test $j -le 6
 do
 CREAR_FICHA $i $j
 j=$(($j+1))
 done
i=$(($i+1))
if test $cont -eq 1
then
j=1
fi
if test $cont -eq 2
then
j=2
fi
if test $cont -eq 3
then
j=3
fi
if test $cont -eq 4
then
j=4
fi

if test $cont -eq 5
then
j=5
fi
if test $cont -eq 6
then
j=6
fi

cont=$(($cont+1))

done
}
#=======================
#REPARTIR LAS FICHAS====
#=======================
function REPARTIR_FICHAS
{
#CASO PARA 2 JUGADORES

if test $JUG -eq 2
then
 if test -f fichasJUG
 then
 rm fichasJUG
 fi
 if test -f fichasPC1
 then
 rm fichasPC1
 fi
 if test -f fichasPC2
 then
 rm fichasPC2
 fi
 if test -f fichasPC3
 then
 rm fichasPC3
 fi

 if test -f POZO
 then
 rm POZO
 fi
# ASIGNAMOS SIETE FICHAS DE LAS FICHAS YA DESORDENADAS A JUGADORES
 head -7 FDESORDEN | tee fichasJUG

# BORRAMOS LAS FICHAS REPARTIDAS A JUGADORES
 cat FDESORDEN | sed '1,7d' > FDESORDEN2.0
# ASIGNAMOS SIETE FICHAS A PC1

 head -7 FDESORDEN2.0 | tee fichasPC1
# BORRAMOS ESAS FICHAS
 cat FDESORDEN2.0 | sed '1,7d' > FDESORDEN2.1
# ASIGNAMOS LAS FICHAS RESTANTES AL POZO
 cat FDESORDEN2.1>POZO

fi
#CASO PARA 3 JUGADORES

if test $JUG -eq 3
then
if test -f fichasJUG
 then
 rm fichasJUG
 fi
 if test -f fichasPC1
 then
 rm fichasPC1
 fi
 if test -f fichasPC2
 then
 rm fichasPC2
 fi

 if test -f fichasPC3
 then
 rm fichasPC3
 fi
 if test -f POZO
 then
 rm POZO
 fi
# ASIGNAMOS SIETE FICHAS A JUGADORES

 head -7 FDESORDEN | tee fichasJUG
# BORRAMOS LAS FICHAS REPARTIDAS A JUGADORES
 cat FDESORDEN | sed '1,7d' > FDESORDEN2.0
# ASIGNAMOS SIETE FICHAS A PC1
 head -7 FDESORDEN2.0 | tee fichasPC1
# BORRAMOS ESAS FICHAS

 cat FDESORDEN2.0 | sed '1,7d' > FDESORDEN2.1

# ASIGNAMOS SIETE FICHAS A PC2
 head -7 FDESORDEN2.1 | tee fichasPC2

# BORRAMOS ESAS FICHAS
 cat FDESORDEN2.1 | sed '1,7d' > FDESORDEN2.2
# ASIGNAMOS LAS FICHAS RESTANTES AL POZO

 cat FDESORDEN2.2>POZO
fi


#CASO PARA 4 JUGADORES

if test $JUG -eq 4
then

if test -f fichasJUG
 then
 rm fichasJUG
 fi

 if test -f fichasPC1
 then
 rm fichasPC1
 fi

 if test -f fichasPC2
 then
 rm fichasPC2
 fi
 if test -f fichasPC3
 then
 rm fichasPC3
 fi
 if test -f POZO
 then
 rm POZO
 fi


# ASIGNAMOS SIETE FICHAS A JUGADORES
 head -7 FDESORDEN | tee fichasJUG

# BORRAMOS LAS FICHAS REPARTIDAS A JUGADORES
 cat FDESORDEN | sed '1,7d'>FDESORDEN2.0
# ASIGNAMOS SIETE FICHAS A PC1
 head -7 FDESORDEN2.0 | tee fichasPC1

# BORRAMOS ESAS FICHAS
 cat FDESORDEN2.0 | sed '1,7d'>FDESORDEN2.1

# ASIGNAMOS SIETE FICHAS A PC2
 head -7 FDESORDEN2.1 | tee fichasPC2
# BORRAMOS ESAS FICHAS

 cat FDESORDEN2.1 | sed '1,7d'>FDESORDEN2.2

# ASIGNAMOS SIETE FICHAS A PC3

 head -7 FDESORDEN2.2 | tee fichasPC3
# BORRAMOS ESAS FICHAS
 cat FDESORDEN2.2 | sed '1,7d'>FDESORDEN2.3

fi

}
#FUNCION PARA ALMACENAR LAS FICHAS DEL FICHERO JUGADOR EN UNA VARIABLE
#==============================
#FICHAS DEL JUGADOR HUMANO=====
#==============================
#FICHA Y LADOS SEPARADOS=======
#==============================
function FICHAS_JUG
{

IN_FILE='./fichasJUG'

i=0
while read -ra LINE
do
 LADO1_JUG[$i]="${LINE[0]}"
 LADO2_JUG[$i]="${LINE[2]}"

 L1=${LADO1_JUG[$i]}
 L2=${LADO2_JUG[$i]}

 FJUG[$i]="$L1$L2"
 i=$(($i+1))
done < "$IN_FILE"



echo "FICHAS JUGADOR"

for j in 0 1 2 3 4 5 6
do
 echo "[ ${LADO1_JUG[$j]} | ${LADO2_JUG[$j]} ]"

done


echo ${FJUG[@]}
}
#FUNCION PARA ALMACENAR LAS FICHAS DEL FICHERO PC1 EN UNA VARIABLE
#====================================
#FICHAS DEL JUGADOR ARTIFICIAL 1=====
#====================================
#FICHA Y LADOS SEPARADOS=============
#====================================


function FICHAS_PC1
{
IN_FILE='./fichasPC1'

i=0

while read -ra LINE
do

 LADO1_PC1[$i]="${LINE[0]}"

 LADO2_PC1[$i]="${LINE[2]}"
 M1=${LADO1_PC1[$i]}
 M2=${LADO2_PC1[$i]}

 FPC1[$i]="$M1$M2"

 i=$(($i+1))

done < "$IN_FILE"
echo "FICHAS PC1"
for j in 0 1 2 3 4 5 6
do

 echo "[ ${LADO1_PC1[$j]} | ${LADO2_PC1[$j]} ] "
done

echo ${FPC1[@]}
}
#====================================
#FICHAS DEL JUGADOR ARTIFICIAL 2=====
#====================================
#FICHA Y LADOS SEPARADOS=============
#====================================
#FUNCION PARA ALMACENAR LAS FICHAS DEL FICHERO PC2 EN UNA VARIABLE

function FICHAS_PC2
{

IN_FILE='./fichasPC2'

i=0

while read -ra LINE
do

 LADO1_PC2[$i]="${LINE[0]}"

 LADO2_PC2[$i]="${LINE[2]}"
 N1=${LADO1_PC2[$i]}
 N2=${LADO2_PC2[$i]}

 FPC2[$i]="$N1$N2"

 i=$(($i+1))
done < "$IN_FILE"
echo "FICHAS PC2"

for j in 0 1 2 3 4 5 6
do
 echo "[ ${LADO1_PC2[$j]} | ${LADO2_PC2[$j]} ] "

done
echo ${FPC2[@]}
}
#====================================
#FICHAS DEL JUGADOR ARTIFICIAL 3=====
#====================================
#FICHA Y LADOS SEPARADOS=============
#====================================

#FUNCION PARA ALMACENAR LAS FICHAS DEL FICHERO PC3 EN UNA VARIABLE
function FICHAS_PC3
{
IN_FILE='./fichasPC3'

i=0
while read -ra LINE
do
 LADO1_PC3[$i]="${LINE[0]}"

 LADO2_PC3[$i]="${LINE[2]}"

 O1=${LADO1_PC3[$i]}
 O2=${LADO2_PC3[$i]}


 FPC3[$i]="$O1$O2"

 i=$(($i+1))
done < "$IN_FILE"

echo "FICHAS PC3"

for j in 0 1 2 3 4 5 6
do

 echo "[ ${LADO1_PC3[$j]} | ${LADO2_PC3[$j]} ] "
done
echo ${FPC3[@]}
}
#====================================
#FICHAS RESTANTES DEL POZO===========
#====================================
#FICHA Y LADOS SEPARADOS=============
#====================================
#FUNCION PARA ALMACENAR LAS FICHAS DEL POZO EN UNA VARIABLE

function FICHAS_POZO
{
IN_FILE='./POZO'


i=0
while read -ra LINE
do

 LADO1_POZO[$i]="${LINE[0]}"
 LADO2_POZO[$i]="${LINE[2]}"
 Q1=${LADO1_POZO[$i]}
 Q2=${LADO2_POZO[$i]}

 FPOZO[$i]="$Q1$Q2"

 i=$(($i+1))

done < "$IN_FILE"
echo "FICHAS POZO (INVISIBLES)"

}

#====================================
#CONCATENA LADOS DE JUGADOR==========
#====================================
function CONCATENAR_LADOS_JUG
{
ficha1J=(${LADO1_JUG[0]}${LADO2_JUG[0]})
ficha2J=(${LADO1_JUG[1]}${LADO2_JUG[1]})
ficha3J=(${LADO1_JUG[2]}${LADO2_JUG[2]})
ficha4J=(${LADO1_JUG[3]}${LADO2_JUG[3]})
ficha5J=(${LADO1_JUG[4]}${LADO2_JUG[4]})
ficha6J=(${LADO1_JUG[5]}${LADO2_JUG[5]})
ficha7J=(${LADO1_JUG[6]}${LADO2_JUG[6]})
}
#====================================
#CONCATENA LADOS DE PC1==============
#====================================

function CONCATENAR_LADOS_PC1
{
ficha1PC1=(${LADO1_PC1[0]}${LADO2_PC1[0]})
ficha2PC1=(${LADO1_PC1[1]}${LADO2_PC1[1]})
ficha3PC1=(${LADO1_PC1[2]}${LADO2_PC1[2]})
ficha4PC1=(${LADO1_PC1[3]}${LADO2_PC1[3]})
ficha5PC1=(${LADO1_PC1[4]}${LADO2_PC1[4]})
ficha6PC1=(${LADO1_PC1[5]}${LADO2_PC1[5]})
ficha7PC1=(${LADO1_PC1[6]}${LADO2_PC1[6]})
}

#====================================
#CONCATENA LADOS DE PC2==============
#====================================
function CONCATENAR_LADOS_PC2
{
ficha1PC2=(${LADO1_PC2[0]}${LADO2_PC2[0]})
ficha2PC2=(${LADO1_PC2[1]}${LADO2_PC2[1]})
ficha3PC2=(${LADO1_PC2[2]}${LADO2_PC2[2]})
ficha4PC2=(${LADO1_PC2[3]}${LADO2_PC2[3]})
ficha5PC2=(${LADO1_PC2[4]}${LADO2_PC2[4]})
ficha6PC2=(${LADO1_PC2[5]}${LADO2_PC2[5]})
ficha7PC2=(${LADO1_PC2[6]}${LADO2_PC2[6]})
}
#====================================
#CONCATENA LADOS DE PC3==============
#====================================
function CONCATENAR_LADOS_PC3
{
ficha1PC3=(${LADO1_PC3[0]}${LADO2_PC3[0]})
ficha2PC3=(${LADO1_PC3[1]}${LADO2_PC3[1]})
ficha3PC3=(${LADO1_PC3[2]}${LADO2_PC3[2]})
ficha4PC3=(${LADO1_PC3[3]}${LADO2_PC3[3]})
ficha5PC3=(${LADO1_PC3[4]}${LADO2_PC3[4]})
ficha6PC3=(${LADO1_PC3[5]}${LADO2_PC3[5]})
ficha7PC3=(${LADO1_PC3[6]}${LADO2_PC3[6]})
}
#====================================
#ELEGIR TURNO DE COMIENZO PARA 2 JUG=
#====================================

function ELEGIR_TURNO_2
{
CONCATENAR_LADOS_JUG
CONCATENAR_LADOS_PC1
ND=1 #NO HAY DOBLES...
ND1=1
#FLAG PARA SABER SI HAY DOBLES O NO
#comparamos todas las fichas de JUG con los posibles valores dobles
 if [[ "$ficha1J" = 00 ]] || [[ "$ficha2J" = 00 ]] || [[ "$ficha3J" = 00 ]] || [[ "$ficha4J" = 00 ]] || [[ "$ficha5J" = 00 ]] || [[ "$ficha6J" = 00 ]] || [[ "$ficha7J" = 00 ]]
 then
 i=0
 ND=0
 fi
 if [[ "$ficha1J" = 11 ]] || [[ "$ficha2J" = 11 ]] || [[ "$ficha3J" = 11 ]] || [[ "$ficha4J" = 11 ]] || [[ "$ficha5J" = 11 ]] || [[ "$ficha6J" = 11 ]] || [[ "$ficha7J" = 11 ]]
 then
 i=1
 ND=0
 fi
 if [[ "$ficha1J" = 22 ]] || [[ "$ficha2J" = 22 ]] || [[ "$ficha3J" = 22 ]] || [[ "$ficha4J" = 22 ]] || [[ "$ficha5J" = 22 ]] || [[ "$ficha6J" = 22 ]] || [[ "$ficha7J" = 22 ]]
 then
 i=2
 ND=0
 fi
 if [[ "$ficha1J" = 33 ]] || [[ "$ficha2J" = 33 ]] || [[ "$ficha3J" = 33 ]] || [[ "$ficha4J" = 33 ]] || [[ "$ficha5J" = 33 ]] || [[ "$ficha6J" = 33 ]] || [[ "$ficha7J" = 33 ]]
 then
 i=3
 ND=0
 fi

 if [[ "$ficha1J" = 44 ]] || [[ "$ficha2J" = 44 ]] || [[ "$ficha3J" = 44 ]] || [[ "$ficha4J" = 44 ]] || [[ "$ficha5J" = 44 ]] || [[ "$ficha6J" = 44 ]] || [[ "$ficha7J" = 44 ]]
 then
 i=4
 ND=0
 fi
 if [[ "$ficha1J" = 55 ]] || [[ "$ficha2J" = 55 ]] || [[ "$ficha3J" = 55 ]] || [[ "$ficha4J" = 55 ]] || [[ "$ficha5J" = 55 ]] || [[ "$ficha6J" = 55 ]] || [[ "$ficha7J" = 55 ]]
 then

 i=5
 ND=0
 fi
 if [[ "$ficha1J" = 66 ]] || [[ "$ficha2J" = 66 ]] || [[ "$ficha3J" = 66 ]] || [[ "$ficha4J" = 66 ]] || [[ "$ficha5J" = 66 ]] || [[ "$ficha6J" = 66 ]] || [[ "$ficha7J" = 66 ]]
 then
 i=6
 ND=0
 fi

#comparamos las fichas de PC1 para ver si tiene dobles
 if [[ "$ficha1PC1" = 00 ]] || [[ "$ficha2PC1" = 00 ]] || [[ "$ficha3PC1" = 00 ]] || [[ "$ficha4PC1" = 00 ]] || [[ "$ficha5PC1" = 00 ]] || [[ "$ficha6PC1" = 00 ]] || [[ "$ficha7PC1" = 00 ]]
 then
 j=0
 ND1=0

 fi
 if [[ "$ficha1PC1" = 11 ]] || [[ "$ficha2PC1" = 11 ]] || [[ "$ficha3PC1" = 11 ]] || [[ "$ficha4PC1" = 11 ]] || [[ "$ficha5PC1" = 11 ]] || [[ "$ficha6PC1" = 11 ]] || [[ "$ficha7PC1" = 11 ]]
 then
 j=1
 ND1=0
 fi
 if [[ "$ficha1PC1" = 22 ]] || [[ "$ficha2PC1" = 22 ]] || [[ "$ficha3PC1" = 22 ]] || [[ "$ficha4PC1" = 22 ]] || [[ "$ficha5PC1" = 22 ]] || [[ "$ficha6PC1" = 22 ]] || [[ "$ficha7PC1" = 22 ]]
 then
 j=2
 ND1=0

 fi
 if [[ "$ficha1PC1" = 33 ]] || [[ "$ficha2PC1" = 33 ]] || [[ "$ficha3PC1" = 33 ]] || [[ "$ficha4PC1" = 33 ]] || [[ "$ficha5PC1" = 33 ]] || [[ "$ficha6PC1" = 33 ]] || [[ "$ficha7PC1" = 33 ]]
 then
 j=3
 ND1=0
 fi

 if [[ "$ficha1PC1" = 44 ]] || [[ "$ficha2PC1" = 44 ]] || [[ "$ficha3PC1" = 44 ]] || [[ "$ficha4PC1" = 44 ]] || [[ "$ficha5PC1" = 44 ]] || [[ "$ficha6PC1" = 44 ]] || [[ "$ficha7PC1" = 44 ]]
 then
 j=4
 ND1=0

 fi
 if [[ "$ficha1PC1" = 55 ]] || [[ "$ficha2PC1" = 55 ]] || [[ "$ficha3PC1" = 55 ]] || [[ "$ficha4PC1" = 55 ]] || [[ "$ficha5PC1" = 55 ]] || [[ "$ficha6PC1" = 55 ]] || [[ "$ficha7PC1" = 55 ]]
 then
 j=5
 ND1=0

 fi
 if [[ "$ficha1PC1" = 66 ]] || [[ "$ficha2PC1" = 66 ]] || [[ "$ficha3PC1" = 66 ]] || [[ "$ficha4PC1" = 66 ]] || [[ "$ficha5PC1" = 66 ]] || [[ "$ficha6PC1" = 66 ]] || [[ "$ficha7PC1" = 66 ]]
 then
 j=6
 ND1=0

 fi


#Si ninguno tiene dobles

 if [[ $ND -ne 0 ]]
 then

#SE CALCULA LA FICHA MAYOR
 if [[ $ficha1J -gt $ficha2J ]] && [[ $ficha1J -gt $ficha3J ]] && [[ $ficha1J -gt $ficha4J ]] && [[ $ficha1J -gt $ficha5J ]] && [[ $ficha1J -gt $ficha6J ]] && [[ $ficha1J -gt $ficha7J ]]
 then
 mayorJ=$ficha1J

 elif [[ $ficha2J -gt $ficha1J ]] && [[ $ficha2J -gt $ficha3J ]] && [[ $ficha2J -gt $ficha4J ]] && [[ $ficha2J -gt $ficha5J ]] && [[ $ficha2J -gt $ficha6J ]] && [[ $ficha2J -gt $ficha7J ]]
 then
 mayorJ=$ficha2J

 elif [[ $ficha3J -gt $ficha1J ]] && [[ $ficha3J -gt $ficha2J ]] && [[ $ficha3J -gt $ficha4J ]] && [[ $ficha3J -gt $ficha5J ]] && [[ $ficha3J -gt $ficha6J ]] && [[ $ficha3J -gt $ficha7J ]]
 then
 mayorJ=$ficha3J
 elif [[ $ficha4J -gt $ficha1J ]] && [[ $ficha4J -gt $ficha2J ]] && [[ $ficha4J -gt $ficha3J ]] && [[ $ficha4J -gt $ficha5J ]] && [[ $ficha4J -gt $ficha6J ]] && [[ $ficha4J -gt $ficha7J ]]
 then
 mayorJ=$ficha4J

 elif [[ $ficha5J -gt $ficha1J ]] && [[ $ficha5J -gt $ficha2J ]] && [[ $ficha5J -gt $ficha3J ]] && [[ $ficha5J -gt $ficha4J ]] && [[ $ficha5J -gt $ficha6J ]] && [[ $ficha5J -gt $ficha7J ]]
 then
 mayorJ=$ficha5J
 elif [[ $ficha6J -gt $ficha1J ]] && [[ $ficha6J -gt $ficha3J ]] && [[ $ficha6J -gt $ficha4J ]] && [[ $ficha6J -gt $ficha5J ]] && [[ $ficha6J -gt $ficha2J ]] && [[ $ficha6J -gt $ficha7J ]]
 then
 mayorJ=$ficha6J

 elif [[ $ficha7J -gt $ficha1J ]] && [[ $ficha7J -gt $ficha3J ]] && [[ $ficha7J -gt $ficha4J ]] && [[ $ficha7J -gt $ficha5J ]] && [[ $ficha7J -gt $ficha6J ]] && [[ $ficha7J -gt $ficha2J ]]
 then
 mayorJ=$ficha7J
 fi
 fi

 if [[ $ND1 -ne 0 ]]
 then
#SE CALCULA LA FICHA MAYOR
 if [[ $ficha1PC1 -gt $ficha2PC1 ]] && [[ $ficha1PC1 -gt $ficha3PC1 ]] && [[ $ficha1PC1 -gt $ficha4PC1 ]] && [[ $ficha1PC1 -gt $ficha5PC1 ]] && [[ $ficha1PC1 -gt $ficha6PC1 ]] && [[
$ficha1PC1 -gt $ficha7PC1 ]]
 then
 mayorPC1=$ficha1PC1

 elif [[ $ficha2PC1 -gt $ficha1PC1 ]] && [[ $ficha2PC1 -gt $ficha3PC1 ]] && [[ $ficha2PC1 -gt $ficha4PC1 ]] && [[ $ficha2PC1 -gt $ficha5PC1 ]] && [[ $ficha2PC1 -gt $ficha6PC1 ]] && [[
$ficha2PC1 -gt $ficha7PC1 ]]
 then
 mayorPC1=$ficha2PC1

 elif [[ $ficha3PC1 -gt $ficha1PC1 ]] && [[ $ficha3PC1 -gt $ficha2PC1 ]] && [[ $ficha3PC1 -gt $ficha4PC1 ]] && [[ $ficha3PC1 -gt $ficha5PC1 ]] && [[ $ficha3PC1 -gt $ficha6PC1 ]] && [[
$ficha3PC1 -gt $ficha7PC1 ]]
 then
 mayorPC1=$ficha3PC1

 elif [[ $ficha4PC1 -gt $ficha1PC1 ]] && [[ $ficha4PC1 -gt $ficha2PC1 ]] && [[ $ficha4PC1 -gt $ficha3PC1 ]] && [[ $ficha4PC1 -gt $ficha5PC1 ]] && [[ $ficha4PC1 -gt $ficha6PC1 ]] && [[
$ficha4PC1 -gt $ficha7PC1 ]]
 then
 mayorPC1=$ficha4PC1

 elif [[ $ficha5PC1 -gt $ficha1PC1 ]] && [[ $ficha5PC1 -gt $ficha2PC1 ]] && [[ $ficha5PC1 -gt $ficha3PC1 ]] && [[ $ficha5PC1 -gt $ficha4PC1 ]] && [[ $ficha5PC1 -gt $ficha6PC1 ]] && [[
$ficha5PC1 -gt $ficha7PC1 ]]
 then
 mayorPC1=$ficha5PC1
 elif [[ $ficha6PC1 -gt $ficha1PC1 ]] && [[ $ficha6PC1 -gt $ficha3PC1 ]] && [[ $ficha6PC1 -gt $ficha4PC1 ]] && [[ $ficha6PC1 -gt $ficha5PC1 ]] && [[ $ficha6PC1 -gt $ficha2PC1 ]] && [[
$ficha6PC1 -gt $ficha7PC1 ]]
 then
 mayorPC1=$ficha6PC1
 elif [[ $ficha7PC1 -gt $ficha1PC1 ]] && [[ $ficha7PC1 -gt $ficha3PC1 ]] && [[ $ficha7PC1 -gt $ficha4PC1 ]] && [[ $ficha7PC1 -gt $ficha5PC1 ]] && [[ $ficha7PC1 -gt $ficha6PC1 ]] && [[ $ficha7PC1$
 then
 mayorPC1=$ficha7PC1


 fi
 fi

#SI LOS DOS TIENEN DOBLES

if [[ $ND -eq 0 ]] && [[ $ND1 -eq 0 ]]
then

 if [[ $i -gt $j ]]
 then
 turno=0
 RESUL_TURNO="$i$i"
 elif [[ $j -gt $i ]]
 then

 turno=1
 RESUL_TURNO="$j$j"

 fi

fi


#SI NINGUNO TIENE DOBLES

if [[ $ND -eq 1 ]] && [[ $ND1 -eq 1 ]]
then
 if [[ $mayorJ -gt $mayorPC1 ]]
 then
 turno=0
 RESUL_TURNO=$mayorJ
 elif [[ $mayorPC1 -gt $mayorJ ]]
 then

 turno=1
 RESUL_TURNO=$mayorPC1

 fi
fi

#SI UNO TIENE DOBLES Y EL OTRO NO

if [[ $ND -eq 0 ]] && [[ $ND1 -eq 1 ]]
then
 turno=0
 RESUL_TURNO="$i$i"
elif [[ $ND -eq 1 ]] && [[ $ND1 -eq 0 ]]
then

 turno=1
 RESUL_TURNO="$j$j"
fi
}

#====================================
#ELEGIR TURNO DE COMIENZO PARA 3 JUG=
#====================================
function ELEGIR_TURNO_3
{

CONCATENAR_LADOS_JUG
CONCATENAR_LADOS_PC1
CONCATENAR_LADOS_PC2
ND=1
ND1=1
ND2=1
#FLAG PARA SABER SI HAY DOBLES O NO

#comparamos todas las fichas de JUG con los posibles valores dobles

 if [[ "$ficha1J" = 00 ]] || [[ "$ficha2J" = 00 ]] || [[ "$ficha3J" = 00 ]] || [[ "$ficha4J" = 00 ]] || [[ "$ficha5J" = 00 ]] || [[ "$ficha6J" = 00 ]] || [[ "$ficha7J" = 00 ]]
 then

 i=0
 ND=0
 fi

 if [[ "$ficha1J" = 11 ]] || [[ "$ficha2J" = 11 ]] || [[ "$ficha3J" = 11 ]] || [[ "$ficha4J" = 11 ]] || [[ "$ficha5J" = 11 ]] || [[ "$ficha6J" = 11 ]] || [[ "$ficha7J" = 11 ]]
 then

 i=1
 ND=0
 fi

 if [[ "$ficha1J" = 22 ]] || [[ "$ficha2J" = 22 ]] || [[ "$ficha3J" = 22 ]] || [[ "$ficha4J" = 22 ]] || [[ "$ficha5J" = 22 ]] || [[ "$ficha6J" = 22 ]] || [[ "$ficha7J" = 22 ]]
 then
 i=2
 ND=0

 fi

 if [[ "$ficha1J" = 33 ]] || [[ "$ficha2J" = 33 ]] || [[ "$ficha3J" = 33 ]] || [[ "$ficha4J" = 33 ]] || [[ "$ficha5J" = 33 ]] || [[ "$ficha6J" = 33 ]] || [[ "$ficha7J" = 33 ]]
 then
 i=3
 ND=0
 fi
 if [[ "$ficha1J" = 44 ]] || [[ "$ficha2J" = 44 ]] || [[ "$ficha3J" = 44 ]] || [[ "$ficha4J" = 44 ]] || [[ "$ficha5J" = 44 ]] || [[ "$ficha6J" = 44 ]] || [[ "$ficha7J" = 44 ]]
 then
 i=4
 ND=0
 fi
 if [[ "$ficha1J" = 55 ]] || [[ "$ficha2J" = 55 ]] || [[ "$ficha3J" = 55 ]] || [[ "$ficha4J" = 55 ]] || [[ "$ficha5J" = 55 ]] || [[ "$ficha6J" = 55 ]] || [[ "$ficha7J" = 55 ]]
 then
 i=5
 ND=0
 fi
 if [[ "$ficha1J" = 66 ]] || [[ "$ficha2J" = 66 ]] || [[ "$ficha3J" = 66 ]] || [[ "$ficha4J" = 66 ]] || [[ "$ficha5J" = 66 ]] || [[ "$ficha6J" = 66 ]] || [[ "$ficha7J" = 66 ]]
 then
 i=6
 ND=0
 fi

#comparamos las fichas de PC1 para ver si tiene dobles
 if [[ "$ficha1PC1" = 00 ]] || [[ "$ficha2PC1" = 00 ]] || [[ "$ficha3PC1" = 00 ]] || [[ "$ficha4PC1" = 00 ]] || [[ "$ficha5PC1" = 00 ]] || [[ "$ficha6PC1" = 00 ]] || [[ "$ficha7PC1" = 00 ]]
 then
 j=0
 ND1=0

 fi
 if [[ "$ficha1PC1" = 11 ]] || [[ "$ficha2PC1" = 11 ]] || [[ "$ficha3PC1" = 11 ]] || [[ "$ficha4PC1" = 11 ]] || [[ "$ficha5PC1" = 11 ]] || [[ "$ficha6PC1" = 11 ]] || [[ "$ficha7PC1" = 11 ]]
 then
 j=1
 ND1=0

 fi

 if [[ "$ficha1PC1" = 22 ]] || [[ "$ficha2PC1" = 22 ]] || [[ "$ficha3PC1" = 22 ]] || [[ "$ficha4PC1" = 22 ]] || [[ "$ficha5PC1" = 22 ]] || [[ "$ficha6PC1" = 22 ]] || [[ "$ficha7PC1" = 22 ]]
 then
 j=2
 ND1=0

 fi
 if [[ "$ficha1PC1" = 33 ]] || [[ "$ficha2PC1" = 33 ]] || [[ "$ficha3PC1" = 33 ]] || [[ "$ficha4PC1" = 33 ]] || [[ "$ficha5PC1" = 33 ]] || [[ "$ficha6PC1" = 33 ]] || [[ "$ficha7PC1" = 33 ]]
 then
 j=3
 ND1=0

 fi

 if [[ "$ficha1PC1" = 44 ]] || [[ "$ficha2PC1" = 44 ]] || [[ "$ficha3PC1" = 44 ]] || [[ "$ficha4PC1" = 44 ]] || [[ "$ficha5PC1" = 44 ]] || [[ "$ficha6PC1" = 44 ]] || [[ "$ficha7PC1" = 44 ]]
 then

 j=4
 ND1=0

 fi

 if [[ "$ficha1PC1" = 55 ]] || [[ "$ficha2PC1" = 55 ]] || [[ "$ficha3PC1" = 55 ]] || [[ "$ficha4PC1" = 55 ]] || [[ "$ficha5PC1" = 55 ]] || [[ "$ficha6PC1" = 55 ]] || [[ "$ficha7PC1" = 55 ]]
 then

 j=5
 ND1=0

 fi
 if [[ "$ficha1PC1" = 66 ]] || [[ "$ficha2PC1" = 66 ]] || [[ "$ficha3PC1" = 66 ]] || [[ "$ficha4PC1" = 66 ]] || [[ "$ficha5PC1" = 66 ]] || [[ "$ficha6PC1" = 66 ]] || [[ "$ficha7PC1" = 66 ]]
 then
 j=6
 ND1=0

 fi
#CON PC2

 if [[ "$ficha1PC2" = 00 ]] || [[ "$ficha2PC2" = 00 ]] || [[ "$ficha3PC2" = 00 ]] || [[ "$ficha4PC2" = 00 ]] || [[ "$ficha5PC2" = 00 ]] || [[ "$ficha6PC2" = 00 ]] || [[ "$ficha7PC2" = 00 ]]
 then
 k=0
 ND2=0

 fi

 if [[ "$ficha1PC2" = 11 ]] || [[ "$ficha2PC2" = 11 ]] || [[ "$ficha3PC2" = 11 ]] || [[ "$ficha4PC2" = 11 ]] || [[ "$ficha5PC2" = 11 ]] || [[ "$ficha6PC2" = 11 ]] || [[ "$ficha7PC2" = 11 ]]
 then
 k=1
 ND2=0
 fi
 if [[ "$ficha1PC2" = 22 ]] || [[ "$ficha2PC2" = 22 ]] || [[ "$ficha3PC2" = 22 ]] || [[ "$ficha4PC2" = 22 ]] || [[ "$ficha5PC2" = 22 ]] || [[ "$ficha6PC2" = 22 ]] || [[ "$ficha7PC2" = 22 ]]
 then
 k=2
 ND2=0

 fi
 if [[ "$ficha1PC2" = 33 ]] || [[ "$ficha2PC2" = 33 ]] || [[ "$ficha3PC2" = 33 ]] || [[ "$ficha4PC2" = 33 ]] || [[ "$ficha5PC2" = 33 ]] || [[ "$ficha6PC2" = 33 ]] || [[ "$ficha7PC2" = 33 ]]
 then

 k=3
 ND2=0

 fi

 if [[ "$ficha1PC2" = 44 ]] || [[ "$ficha2PC2" = 44 ]] || [[ "$ficha3PC2" = 44 ]] || [[ "$ficha4PC2" = 44 ]] || [[ "$ficha5PC2" = 44 ]] || [[ "$ficha6PC2" = 44 ]] || [[ "$ficha7PC2" = 44 ]]
 then

 k=4
 ND2=0
 fi

 if [[ "$ficha1PC2" = 55 ]] || [[ "$ficha2PC2" = 55 ]] || [[ "$ficha3PC2" = 55 ]] || [[ "$ficha4PC2" = 55 ]] || [[ "$ficha5PC2" = 55 ]] || [[ "$ficha6PC2" = 55 ]] || [[ "$ficha7PC2" = 55 ]]
 then

 k=5
 ND2=0
 fi

 if [[ "$ficha1PC2" = 66 ]] || [[ "$ficha2PC2" = 66 ]] || [[ "$ficha3PC2" = 66 ]] || [[ "$ficha4PC2" = 66 ]] || [[ "$ficha5PC2" = 66 ]] || [[ "$ficha6PC2" = 66 ]] || [[ "$ficha7PC2" = 66 ]]
 then
 k=6
 ND2=0

 fi


#Si ninguno tiene dobles

 if [[ $ND -ne 0 ]]
 then
#SE CALCULA LA FICHA MAYOR

 if [[ $ficha1J -gt $ficha2J ]] && [[ $ficha1J -gt $ficha3J ]] && [[ $ficha1J -gt $ficha4J ]] && [[ $ficha1J -gt $ficha5J ]] && [[ $ficha1J -gt $ficha6J ]] && [[ $ficha1J -gt $ficha7J ]]
 then
 mayorJ=$ficha1J

 elif [[ $ficha2J -gt $ficha1J ]] && [[ $ficha2J -gt $ficha3J ]] && [[ $ficha2J -gt $ficha4J ]] && [[ $ficha2J -gt $ficha5J ]] && [[ $ficha2J -gt $ficha6J ]] && [[ $ficha2J -gt $ficha7J ]]
 then
 mayorJ=$ficha2J

 elif [[ $ficha3J -gt $ficha1J ]] && [[ $ficha3J -gt $ficha2J ]] && [[ $ficha3J -gt $ficha4J ]] && [[ $ficha3J -gt $ficha5J ]] && [[ $ficha3J -gt $ficha6J ]] && [[ $ficha3J -gt $ficha7J ]]
 then
 mayorJ=$ficha3J

 elif [[ $ficha4J -gt $ficha1J ]] && [[ $ficha4J -gt $ficha2J ]] && [[ $ficha4J -gt $ficha3J ]] && [[ $ficha4J -gt $ficha5J ]] && [[ $ficha4J -gt $ficha6J ]] && [[ $ficha4J -gt $ficha7J ]]
 then
 mayorJ=$ficha4J
 elif [[ $ficha5J -gt $ficha1J ]] && [[ $ficha5J -gt $ficha2J ]] && [[ $ficha5J -gt $ficha3J ]] && [[ $ficha5J -gt $ficha4J ]] && [[ $ficha5J -gt $ficha6J ]] && [[ $ficha5J -gt $ficha7J ]]
 then
 mayorJ=$ficha5J
 elif [[ $ficha6J -gt $ficha1J ]] && [[ $ficha6J -gt $ficha3J ]] && [[ $ficha6J -gt $ficha4J ]] && [[ $ficha6J -gt $ficha5J ]] && [[ $ficha6J -gt $ficha2J ]] && [[ $ficha6J -gt $ficha7J ]]
 then
 mayorJ=$ficha6J

 elif [[ $ficha7J -gt $ficha1J ]] && [[ $ficha7J -gt $ficha3J ]] && [[ $ficha7J -gt $ficha4J ]] && [[ $ficha7J -gt $ficha5J ]] && [[ $ficha7J -gt $ficha6J ]] && [[ $ficha7J -gt $ficha2J ]]
 then
 mayorJ=$ficha7J

 fi
 fi
 if [[ $ND1 -ne 0 ]]
 then

#SE CALCULA LA FICHA MAYOR

 if [[ $ficha1PC1 -gt $ficha2PC1 ]] && [[ $ficha1PC1 -gt $ficha3PC1 ]] && [[ $ficha1PC1 -gt $ficha4PC1 ]] && [[ $ficha1PC1 -gt $ficha5PC1 ]] && [[ $ficha1PC1 -gt $ficha6PC1 ]] && [[
$ficha1PC1 -gt $ficha7PC1 ]]
 then
 mayorPC1=$ficha1PC1
 elif [[ $ficha2PC1 -gt $ficha1PC1 ]] && [[ $ficha2PC1 -gt $ficha3PC1 ]] && [[ $ficha2PC1 -gt $ficha4PC1 ]] && [[ $ficha2PC1 -gt $ficha5PC1 ]] && [[ $ficha2PC1 -gt $ficha6PC1 ]] && [[
$ficha2PC1 -gt $ficha7PC1 ]]
 then
 mayorPC1=$ficha2PC1
 elif [[ $ficha3PC1 -gt $ficha1PC1 ]] && [[ $ficha3PC1 -gt $ficha2PC1 ]] && [[ $ficha3PC1 -gt $ficha4PC1 ]] && [[ $ficha3PC1 -gt $ficha5PC1 ]] && [[ $ficha3PC1 -gt $ficha6PC1 ]] && [[
$ficha3PC1 -gt $ficha7PC1 ]]
 then
 mayorPC1=$ficha3PC1

 elif [[ $ficha4PC1 -gt $ficha1PC1 ]] && [[ $ficha4PC1 -gt $ficha2PC1 ]] && [[ $ficha4PC1 -gt $ficha3PC1 ]] && [[ $ficha4PC1 -gt $ficha5PC1 ]] && [[ $ficha4PC1 -gt $ficha6PC1 ]] && [[
$ficha4PC1 -gt $ficha7PC1 ]]
 then
 mayorPC1=$ficha4PC1

 elif [[ $ficha5PC1 -gt $ficha1PC1 ]] && [[ $ficha5PC1 -gt $ficha2PC1 ]] && [[ $ficha5PC1 -gt $ficha3PC1 ]] && [[ $ficha5PC1 -gt $ficha4PC1 ]] && [[ $ficha5PC1 -gt $ficha6PC1 ]] && [[
$ficha5PC1 -gt $ficha7PC1 ]]
 then
 mayorPC1=$ficha5PC1

 elif [[ $ficha6PC1 -gt $ficha1PC1 ]] && [[ $ficha6PC1 -gt $ficha3PC1 ]] && [[ $ficha6PC1 -gt $ficha4PC1 ]] && [[ $ficha6PC1 -gt $ficha5PC1 ]] && [[ $ficha6PC1 -gt $ficha2PC1 ]] && [[
$ficha6PC1 -gt $ficha7PC1 ]]
 then
 mayorPC1=$ficha6PC1

 elif [[ $ficha7PC1 -gt $ficha1PC1 ]] && [[ $ficha7PC1 -gt $ficha3PC1 ]] && [[ $ficha7PC1 -gt $ficha4PC1 ]] && [[ $ficha7PC1 -gt $ficha5PC1 ]] && [[ $ficha7PC1 -gt $ficha6PC1 ]] && [[
$ficha7PC1 -gt $ficha2PC1 ]]
 then
 mayorPC1=$ficha7PC1



 fi
 fi


if [[ $ND2 -ne 0 ]]
 then

#SE CALCULA LA FICHA MAYOR
 if [[ $ficha1PC2 -gt $ficha2PC2 ]] && [[ $ficha1PC2 -gt $ficha3PC2 ]] && [[ $ficha1PC2 -gt $ficha4PC2 ]] && [[ $ficha1PC2 -gt $ficha5PC2 ]] && [[ $ficha1PC2 -gt $ficha6PC2 ]] && [[
$ficha1PC2 -gt $ficha7PC2 ]]
 then
 mayorPC2=$ficha1PC2
 elif [[ $ficha2PC2 -gt $ficha1PC2 ]] && [[ $ficha2PC2 -gt $ficha3PC2 ]] && [[ $ficha2PC2 -gt $ficha4PC2 ]] && [[ $ficha2PC2 -gt $ficha5PC2 ]] && [[ $ficha2PC2 -gt $ficha6PC2 ]] && [[
$ficha2PC2 -gt $ficha7PC2 ]]
 then
 mayorPC2=$ficha2PC2
 elif [[ $ficha3PC2 -gt $ficha1PC2 ]] && [[ $ficha3PC2 -gt $ficha2PC2 ]] && [[ $ficha3PC2 -gt $ficha4PC2 ]] && [[ $ficha3PC2 -gt $ficha5PC2 ]] && [[ $ficha3PC2 -gt $ficha6PC2 ]] && [[
$ficha3PC2 -gt $ficha7PC2 ]]
 then
 mayorPC2=$ficha3PC2

 elif [[ $ficha4PC2 -gt $ficha1PC2 ]] && [[ $ficha4PC2 -gt $ficha2PC2 ]] && [[ $ficha4PC2 -gt $ficha3PC2 ]] && [[ $ficha4PC2 -gt $ficha5PC2 ]] && [[ $ficha4PC2 -gt $ficha6PC2 ]] && [[
$ficha4PC2 -gt $ficha7PC2 ]]
 then
 mayorPC2=$ficha4PC2

 elif [[ $ficha5PC2 -gt $ficha1PC2 ]] && [[ $ficha5PC2 -gt $ficha2PC2 ]] && [[ $ficha5PC2 -gt $ficha3PC2 ]] && [[ $ficha5PC2 -gt $ficha4PC2 ]] && [[ $ficha5PC2 -gt $ficha6PC2 ]] && [[
$ficha5PC2 -gt $ficha7PC2 ]]
 then
 mayorPC2=$ficha5PC2

 elif [[ $ficha6PC2 -gt $ficha1PC2 ]] && [[ $ficha6PC2 -gt $ficha3PC2 ]] && [[ $ficha6PC2 -gt $ficha4PC2 ]] && [[ $ficha6PC2 -gt $ficha5PC2 ]] && [[ $ficha6PC2 -gt $ficha2PC2 ]] && [[
$ficha6PC2 -gt $ficha7PC2 ]]
 then
 mayorPC2=$ficha6PC2

 elif [[ $ficha7PC2 -gt $ficha1PC2 ]] && [[ $ficha7PC2 -gt $ficha3PC2 ]] && [[ $ficha7PC2 -gt $ficha4PC2 ]] && [[ $ficha7PC2 -gt $ficha5PC2 ]] && [[ $ficha7PC2 -gt $ficha6PC2 ]] && [[
$ficha7PC2 -gt $ficha2PC2 ]]
 then
 mayorPC2=$ficha7PC2
 fi
 fi

#SI LOS DOS TIENEN DOBLES

if [[ $ND -eq 0 ]] && [[ $ND1 -eq 0 ]] && [[ $ND2 -eq 0 ]]
then

 if [[ $i -gt $j ]] && [[ $i -gt $k ]]
 then

 echo "EMPIEZA JUG POR TENER EL DOBLE MAS GRANDE"
 turno=0
 RESUL_TURNO="$i$i"
 elif [[ $j -gt $i ]] && [[ $j -gt $k ]]

 then
 echo "EMPIEZA PC1 POR TENER EL DOBLE MAS GRANDE"
 turno=1
 RESUL_TURNO="$j$j"
 elif [[ $k -gt $j ]] && [[ $k -gt $i ]]
 then

 echo "EMPIEZA PC2 POR TENER EL DOBLE MAS GRANDE"
 turno=2
 RESUL_TURNO="$k$k"
 fi
fi


#SI NINGUNO TIENE DOBLES

if [[ $ND -eq 1 ]] && [[ $ND1 -eq 1 ]] && [[ $ND2 -eq 1 ]]
then

 if [[ $mayorJ -gt $mayorPC1 ]] && [[ $mayorJ -gt $mayorPC2 ]]
 then

 echo "EMPIEZA JUG POR TENER LA FICHAS CON MAS PUNTOS"
 turno=0
 RESUL_TURNO=$mayorJ

 elif [[ $mayorPC1 -gt $mayorJ ]] && [[ $mayorPC1 -gt $mayorPC2 ]]
 then

 echo "EMPIEZA PC1 POR TENER LA FICHA CON MAS PUNTOS"
 turno=1
 RESUL_TURNO=$mayorPC1
 elif [[ $mayorPC2 -gt $mayorJ ]] && [[ $mayorPC2 -gt $mayorPC1 ]]
 then
 echo "EMPIEZA PC2 POR TENER LA FICHA CON MAS PUNTOS"
 turno=2
 RESUL_TURNO=$mayorPC2

 fi
fi
if [[ $ND -eq 0 ]] && [[ $ND1 -eq 1 ]] && [[ $ND2 -eq 1 ]]
then
 echo "EMPIEZA JUG POR SER EL UNICO CON DOBLES"
 turno=0
 RESUL_TURNO="$i$i"

elif [[ $ND -eq 1 ]] && [[ $ND1 -eq 0 ]] && [[ $ND2 -eq 1 ]]
then

 echo "EMPIEZA PC1 POR SER EL UNICO CON DOBLES"
 turno=1
 RESUL_TURNO="$j$j"

elif [[ $ND -eq 1 ]] && [[ $ND1 -eq 1 ]] && [[ $ND2 -eq 0 ]]
then

 echo "EMPIEZA PC2 POR SER EL UNICO CON DOBLES"
 turno=2
 RESUL_TURNO="$k$k"

fi
}

#====================================
#ELEGIR TURNO DE COMIENZO PARA 4 JUG=
#====================================

function ELEGIR_TURNO_4
{

CONCATENAR_LADOS_JUG
CONCATENAR_LADOS_PC1
CONCATENAR_LADOS_PC2
CONCATENAR_LADOS_PC3

ND=1
ND1=1
ND2=1
ND3=1
#FLAG PARA SABER SI HAY DOBLES O NO

#comparamos todas las fichas de JUG con los posibles valores dobles

 if [[ "$ficha1J" = 00 ]] || [[ "$ficha2J" = 00 ]] || [[ "$ficha3J" = 00 ]] || [[ "$ficha4J" = 00 ]] || [[ "$ficha5J" = 00 ]] || [[ "$ficha6J" = 00 ]] || [[ "$ficha7J" = 00 ]]
 then
 i=0
 ND=0
 fi

 if [[ "$ficha1J" = 11 ]] || [[ "$ficha2J" = 11 ]] || [[ "$ficha3J" = 11 ]] || [[ "$ficha4J" = 11 ]] || [[ "$ficha5J" = 11 ]] || [[ "$ficha6J" = 11 ]] || [[ "$ficha7J" = 11 ]]
 then
 i=1
 ND=0

 fi

 if [[ "$ficha1J" = 22 ]] || [[ "$ficha2J" = 22 ]] || [[ "$ficha3J" = 22 ]] || [[ "$ficha4J" = 22 ]] || [[ "$ficha5J" = 22 ]] || [[ "$ficha6J" = 22 ]] || [[ "$ficha7J" = 22 ]]
 then
 i=2
 ND=0

 fi

 if [[ "$ficha1J" = 33 ]] || [[ "$ficha2J" = 33 ]] || [[ "$ficha3J" = 33 ]] || [[ "$ficha4J" = 33 ]] || [[ "$ficha5J" = 33 ]] || [[ "$ficha6J" = 33 ]] || [[ "$ficha7J" = 33 ]]
 then

 i=3
 ND=0
 fi
 if [[ "$ficha1J" = 44 ]] || [[ "$ficha2J" = 44 ]] || [[ "$ficha3J" = 44 ]] || [[ "$ficha4J" = 44 ]] || [[ "$ficha5J" = 44 ]] || [[ "$ficha6J" = 44 ]] || [[ "$ficha7J" = 44 ]]
 then
 i=4
 ND=0
 fi
 if [[ "$ficha1J" = 55 ]] || [[ "$ficha2J" = 55 ]] || [[ "$ficha3J" = 55 ]] || [[ "$ficha4J" = 55 ]] || [[ "$ficha5J" = 55 ]] || [[ "$ficha6J" = 55 ]] || [[ "$ficha7J" = 55 ]]
 then
 i=5
 ND=0

 fi

 if [[ "$ficha1J" = 66 ]] || [[ "$ficha2J" = 66 ]] || [[ "$ficha3J" = 66 ]] || [[ "$ficha4J" = 66 ]] || [[ "$ficha5J" = 66 ]] || [[ "$ficha6J" = 66 ]] || [[ "$ficha7J" = 66 ]]
 then
 i=6
 ND=0
 fi


#comparamos las fichas de PC1 para ver si tiene dobles
 if [[ "$ficha1PC1" = 00 ]] || [[ "$ficha2PC1" = 00 ]] || [[ "$ficha3PC1" = 00 ]] || [[ "$ficha4PC1" = 00 ]] || [[ "$ficha5PC1" = 00 ]] || [[ "$ficha6PC1" = 00 ]] || [[ "$ficha7PC1" = 00 ]]
 then

 j=0
 ND1=0

 fi
 if [[ "$ficha1PC1" = 11 ]] || [[ "$ficha2PC1" = 11 ]] || [[ "$ficha3PC1" = 11 ]] || [[ "$ficha4PC1" = 11 ]] || [[ "$ficha5PC1" = 11 ]] || [[ "$ficha6PC1" = 11 ]] || [[ "$ficha7PC1" = 11 ]]
 then

 j=1
 ND1=0

 fi

 if [[ "$ficha1PC1" = 22 ]] || [[ "$ficha2PC1" = 22 ]] || [[ "$ficha3PC1" = 22 ]] || [[ "$ficha4PC1" = 22 ]] || [[ "$ficha5PC1" = 22 ]] || [[ "$ficha6PC1" = 22 ]] || [[ "$ficha7PC1" = 22 ]]
 then
 j=2
 ND1=0

 fi
 if [[ "$ficha1PC1" = 33 ]] || [[ "$ficha2PC1" = 33 ]] || [[ "$ficha3PC1" = 33 ]] || [[ "$ficha4PC1" = 33 ]] || [[ "$ficha5PC1" = 33 ]] || [[ "$ficha6PC1" = 33 ]] || [[ "$ficha7PC1" = 33 ]]
 then
 j=3
 ND1=0

 fi
 if [[ "$ficha1PC1" = 44 ]] || [[ "$ficha2PC1" = 44 ]] || [[ "$ficha3PC1" = 44 ]] || [[ "$ficha4PC1" = 44 ]] || [[ "$ficha5PC1" = 44 ]] || [[ "$ficha6PC1" = 44 ]] || [[ "$ficha7PC1" = 44 ]]
 then

 j=4
 ND1=0
 fi
 if [[ "$ficha1PC1" = 55 ]] || [[ "$ficha2PC1" = 55 ]] || [[ "$ficha3PC1" = 55 ]] || [[ "$ficha4PC1" = 55 ]] || [[ "$ficha5PC1" = 55 ]] || [[ "$ficha6PC1" = 55 ]] || [[ "$ficha7PC1" = 55 ]]
 then
 j=5
 ND1=0

 fi
 if [[ "$ficha1PC1" = 66 ]] || [[ "$ficha2PC1" = 66 ]] || [[ "$ficha3PC1" = 66 ]] || [[ "$ficha4PC1" = 66 ]] || [[ "$ficha5PC1" = 66 ]] || [[ "$ficha6PC1" = 66 ]] || [[ "$ficha7PC1" = 66 ]]
 then

 j=6
 ND1=0

 fi
#CON PC2

 if [[ "$ficha1PC2" = 00 ]] || [[ "$ficha2PC2" = 00 ]] || [[ "$ficha3PC2" = 00 ]] || [[ "$ficha4PC2" = 00 ]] || [[ "$ficha5PC2" = 00 ]] || [[ "$ficha6PC2" = 00 ]] || [[ "$ficha7PC2" = 00 ]]
 then

 k=0
 ND2=0

 fi

 if [[ "$ficha1PC2" = 11 ]] || [[ "$ficha2PC2" = 11 ]] || [[ "$ficha3PC2" = 11 ]] || [[ "$ficha4PC2" = 11 ]] || [[ "$ficha5PC2" = 11 ]] || [[ "$ficha6PC2" = 11 ]] || [[ "$ficha7PC2" = 11 ]]
 then
 k=1
 ND2=0
 fi

 if [[ "$ficha1PC2" = 22 ]] || [[ "$ficha2PC2" = 22 ]] || [[ "$ficha3PC2" = 22 ]] || [[ "$ficha4PC2" = 22 ]] || [[ "$ficha5PC2" = 22 ]] || [[ "$ficha6PC2" = 22 ]] || [[ "$ficha7PC2" = 22 ]]
 then
 k=2
 ND2=0
 fi

 if [[ "$ficha1PC2" = 33 ]] || [[ "$ficha2PC2" = 33 ]] || [[ "$ficha3PC2" = 33 ]] || [[ "$ficha4PC2" = 33 ]] || [[ "$ficha5PC2" = 33 ]] || [[ "$ficha6PC2" = 33 ]] || [[ "$ficha7PC2" = 33 ]]
 then

 k=3
 ND2=0
 fi

 if [[ "$ficha1PC2" = 44 ]] || [[ "$ficha2PC2" = 44 ]] || [[ "$ficha3PC2" = 44 ]] || [[ "$ficha4PC2" = 44 ]] || [[ "$ficha5PC2" = 44 ]] || [[ "$ficha6PC2" = 44 ]] || [[ "$ficha7PC2" = 44 ]]
 then

 k=4
 ND2=0
 fi

 if [[ "$ficha1PC2" = 55 ]] || [[ "$ficha2PC2" = 55 ]] || [[ "$ficha3PC2" = 55 ]] || [[ "$ficha4PC2" = 55 ]] || [[ "$ficha5PC2" = 55 ]] || [[ "$ficha6PC2" = 55 ]] || [[ "$ficha7PC2" = 55 ]]
 then

 k=5
 ND2=0
 fi

 if [[ "$ficha1PC2" = 66 ]] || [[ "$ficha2PC2" = 66 ]] || [[ "$ficha3PC2" = 66 ]] || [[ "$ficha4PC2" = 66 ]] || [[ "$ficha5PC2" = 66 ]] || [[ "$ficha6PC2" = 66 ]] || [[ "$ficha7PC2" = 66 ]]
 then

 k=6
 ND2=0

 fi
#CON PC3

if [[ "$ficha1PC3" = 00 ]] || [[ "$ficha2PC3" = 00 ]] || [[ "$ficha3PC3" = 00 ]] || [[ "$ficha4PC3" = 00 ]] || [[ "$ficha5PC3" = 00 ]] || [[ "$ficha6PC3" = 00 ]] || [[ "$ficha7PC3" = 00 ]]
 then

 l=0
 ND3=0

 fi

 if [[ "$ficha1PC3" = 11 ]] || [[ "$ficha2PC3" = 11 ]] || [[ "$ficha3PC3" = 11 ]] || [[ "$ficha4PC3" = 11 ]] || [[ "$ficha5PC3" = 11 ]] || [[ "$ficha6PC3" = 11 ]] || [[ "$ficha7PC3" = 11 ]]
 then

 l=1
 ND3=0

 fi

 if [[ "$ficha1PC3" = 22 ]] || [[ "$ficha2PC3" = 22 ]] || [[ "$ficha3PC3" = 22 ]] || [[ "$ficha4PC3" = 22 ]] || [[ "$ficha5PC3" = 22 ]] || [[ "$ficha6PC3" = 22 ]] || [[ "$ficha7PC3" = 22 ]]
 then

 l=2
 ND3=0

 fi
 if [[ "$ficha1PC3" = 33 ]] || [[ "$ficha2PC3" = 33 ]] || [[ "$ficha3PC3" = 33 ]] || [[ "$ficha4PC3" = 33 ]] || [[ "$ficha5PC3" = 33 ]] || [[ "$ficha6PC3" = 33 ]] || [[ "$ficha7PC3" = 33 ]]
 then

 l=3
 ND3=0

 fi

 if [[ "$ficha1PC3" = 44 ]] || [[ "$ficha2PC3" = 44 ]] || [[ "$ficha3PC3" = 44 ]] || [[ "$ficha4PC3" = 44 ]] || [[ "$ficha5PC3" = 44 ]] || [[ "$ficha6PC3" = 44 ]] || [[ "$ficha7PC3" = 44 ]]
 then

 l=4
 ND3=0

 fi

 if [[ "$ficha1PC3" = 55 ]] || [[ "$ficha2PC3" = 55 ]] || [[ "$ficha3PC3" = 55 ]] || [[ "$ficha4PC3" = 55 ]] || [[ "$ficha5PC3" = 55 ]] || [[ "$ficha6PC3" = 55 ]] || [[ "$ficha7PC3" = 55 ]]
 then

 l=5
 ND3=0
 fi

 if [[ "$ficha1PC3" = 66 ]] || [[ "$ficha2PC3" = 66 ]] || [[ "$ficha3PC3" = 66 ]] || [[ "$ficha4PC3" = 66 ]] || [[ "$ficha5PC3" = 66 ]] || [[ "$ficha6PC3" = 66 ]] || [[ "$ficha7PC3" = 66 ]]
 then

 l=6
 ND3=0

 fi


#SI LOS CUATRO TIENEN DOBLES

if [[ $ND -eq 0 ]] && [[ $ND1 -eq 0 ]] && [[ $ND2 -eq 0 ]] && [[ $ND3 -eq 0 ]]
then

 if [[ $i -gt $j ]] && [[ $i -gt $k ]] && [[ $i -gt $l ]]
 then
 echo "EMPIEZA JUG POR TENER EL DOBLE MAS GRANDE"
 turno=0
 RESUL_TURNO="$i$i"

 elif [[ $j -gt $i ]] && [[ $j -gt $k ]] && [[ $j -gt $l ]]
 then

 echo "EMPIEZA PC1 POR TENER EL DOBLE MAS GRANDE"
 turno=1
 RESUL_TURNO="$j$j"

 elif [[ $k -gt $j ]] && [[ $k -gt $i ]] && [[ $k -gt $l ]]
 then

 echo "EMPIEZA PC2 POR TENER EL DOBLE MAS GRANDE"
 turno=2
 RESUL_TURNO="$k$k"

 elif [[ $l -gt $j ]] && [[ $l -gt $k ]] && [[ $l -gt $i ]]
 then

 echo "EMPIEZA PC3 POR TENER EL DOBLE MAS GRANDE"
 turno=3
 RESUL_TURNO="$l$l"

 fi

fi

}

#========================================
#DIVIDE LOS LADOS DE LA FICHA============
#========================================

function DIVIDIR_LADOS
{

 if [[ $1 =~ $COMP ]]
 then
 lado1=$(($1/10))
 lado2=$(($1%10))
 else
 lado1=0
 lado2=0
 fi
}
#=========================================
#DESPLAZAMIENTO DE LAS FICHAS DE JUG =====
#=========================================
#CUANDO ROBA...===========================
#=========================================

function MOVER_FICHAS_JUG
{
 i=0
 j=$(($1-1))


 temp=$(($numFJUG+1))

 while [[ $i -lt $(($temp-$j)) ]]
 do

 FJUG[$(($1+$i))]=${FJUG[$(($1+$i+1))]}


 i=$(($i+1))

 done

}
#=========================================
#DESPLAZAMIENTO DE LAS FICHAS DE PC1======
#=========================================
#CUANDO ROBA...===========================
#=========================================
function MOVER_FICHAS_PC1
{
 i=0
 j=$(($1-1))
 temp=$(($numFPC1+1))

 while [[ $i -lt $(($temp-$j)) ]]
 do

 FPC1[$(($1+$i))]=${FPC1[$(($1+$i+1))]}


 i=$(($i+1))
 done
}

#=========================================
#DESPLAZAMIENTO DE LAS FICHAS DE PC2======
#=========================================
#CUANDO ROBA...===========================
#=========================================


function MOVER_FICHAS_PC2
{
 i=0
 j=$(($1-1))
 temp=$(($numFPC2+1))

 while [[ $i -lt $(($temp-$j)) ]]
 do

 FPC2[$(($1+$i))]=${FPC2[$(($1+$i+1))]}


 i=$(($i+1))
 done
}
#=========================================
#DESPLAZAMIENTO DE LAS FICHAS DE PC3======
#=========================================
#CUANDO ROBA...===========================
#=========================================


function MOVER_FICHAS_PC3
{
 i=0
 j=$(($1-1))
 temp=$(($numFPC3+1))

 while [[ $i -lt $(($temp-$j)) ]]
 do
 FPC3[$(($1+$i))]=${FPC3[$(($1+$i+1))]}
 i=$(($i+1))
 done

}
#===================================================
#MUESTRA EL DESPLAZAMIENTO DEL TABLERO==============
#===================================================

function MOVER_TABLERO_DERECHA
{
 i=$(($numFTABLERO+1))

 while [[ $i -ge 0 ]]
 do

 TABLERO[$(($i+1))]=${TABLERO[$i]}

 i=$(($i-1))

 done

}
#===================================================
#DESPLAZAMIENTO DE LAS FICHAS DEL POZO==============
#===================================================
function MOVER_FICHAS_POZO
{
 i=$1
 length=${#FPOZO[@]}

 while [[ $i -lt $length ]]
 do
 FPOZO[$i]=${FPOZO[$(($i+1))]}

 i=$(($i+1))

 done
length=$(($length-1))
}
#===================================================
#ROBA DEL POZO JUGADOR JUG==========================
#===================================================
function ROBAR_JUG
{
 if [[ $JUG -eq 2 ]]
 then

 if [[ $numPOZO -eq 0 ]]
 then


 CIERRE=$(($CIERRE+1))
 lado=2
 SALIDA=1
 FIN=1


 else

 numPOZO=$((14-$sacadasPOZO))
 numFJUG=$((7-$jugadasJUG))
 aux=$(($RANDOM%$(($(($numPOZO-1))))))
 FJUG[$numFJUG]=${FPOZO[$aux]} #length es 7 ficha[7] es null
 MOVER_FICHAS_POZO $aux

 jugadasJUG=$(($jugadasJUG -1))

 sacadasPOZO=$(($sacadasPOZO+1))

 numFJUG=$(($numFJUG+1))
 posicion=$numFJUG

 lado=2

 echo "HA ROBADO 1 FICHA DEL POZO--> ${FJUG[$(($numFJUG-1))]} quedan $(($numPOZO-1)) fichas en el pozo"
 echo "SUS FICHAS SON: ${FJUG[@]}"
 sleep 2
 fi
 elif [[ $JUG -eq 3 ]]
 then
 if [[ $numPOZO -eq 1 ]]
 then
 CIERRE=$(($CIERRE+1))
 lado=2
 SALIDA=1

 else


 numPOZO=$((7-$sacadasPOZO))

 numFJUG=$((7-$jugadasJUG))

 aux=$(($RANDOM%$(($numPOZO))))

 FJUG[$(($numFJUG))]=${FPOZO[$aux]} #length es 7 ficha[7] es null

 MOVER_FICHAS_POZO $aux
 jugadasJUG=$(($jugadasJUG-1))
 sacadasPOZO=$(($sacadasPOZO+1))
 numFJUG=$(($numFJUG+1))
 posicion=$numFJUG

 lado=2

 echo "HA ROBADO 1 FICHA DEL POZO--> ${FJUG[$numFJUG-1]} quedan $numPOZO fichas en el pozo"
 echo "SUS FICHAS SON: ${FJUG[@]}"
 sleep 2
 fi
 fi

}

#===================================================
#ROBA DEL POZO CUANDO PC1===========================
#===================================================
function ROBAR_PC1
{

echo "AHORA VA A ROBAR PC1"
while [[ $FLAG -eq 0 ]]
do
 if [[ $numPOZO -eq 1 ]]
 then

 CIERRE=$(($CIERRE+1))
 FLAG=1

 else

 aux=$(($RANDOM%$(($numPOZO-1))))

 FPC1[$numFPC1]=${FPOZO[$aux]}

 echo "PC1 ha robado: ${FPC1[$(($numFPC1))]} , quedan $(($numPOZO-1)) fichas"

 MOVER_FICHAS_POZO $aux

 jugadasPC1=$(($jugadasPC1-1))
 sacadasPOZO=$(($sacadasPOZO+1))
 numFPC1=$(($numFPC1+1))
 numPOZO=$(($numPOZO-1))
 DIVIDIR_LADOS ${FPC1[$(($numFPC1-1))]}


if [[ $lado1 -eq $IZQ ]]
then
 IZQ=$lado2
 MOVER_FICHAS_PC1 $(($numFPC1-1))
 MOVER_TABLERO_DERECHA
 TABLERO[0]="$lado2$lado1"
 FLAG=1
 jugadasPC1=$(($jugadasPC1+1))
 numFPC1=$(($numFPC1-1))
 CIERRE=0
 numFTABLERO=$(($numFTABLERO+1))
elif [[ $lado2 -eq $IZQ ]]
then
 IZQ=$lado1
 MOVER_FICHAS_PC1 $(($numFPC1-1))
 MOVER_TABLERO_DERECHA
 TABLERO[0]="$lado1$lado2"

 FLAG=1
 jugadasPC1=$(($jugadasPC1+1))
 numFPC1=$(($numFPC1-1))
 CIERRE=0
 numFTABLERO=$(($numFTABLERO+1))


elif [[ $lado1 -eq $DER ]]
then
 DER=$lado2
 TABLERO[$(($numFTABLERO))]="$lado1$lado2"
 MOVER_FICHAS_PC1 $(($numFPC1-1))
 FLAG=1
 jugadasPC1=$(($jugadasPC1+1))
 numFTABLERO=$(($numFTABLERO+1))
 numFPC1=$(($numFPC1-1))
 CIERRE=0

elif [[ $lado2 -eq $DER ]]
then
 DER=$lado1
 TABLERO[$(($numFTABLERO))]="$lado2$lado1"
 MOVER_FICHAS_PC1 $(($numFPC1-1))
 FLAG=1
 jugadasPC1=$(($jugadasPC1+1))
 numFTABLERO=$(($numFTABLERO+1))
 numFPC1=$(($numFPC1-1))
 CIERRE=0

fi

fi

done



}

#===================================================
#ROBA DEL POZO JUGADOR PC2==========================
#===================================================

function ROBAR_PC2
{

echo "AHORA VA A ROBAR PC2"
while [[ $FLAG -eq 0 ]]
do

 if [[ $numPOZO -eq 1 ]]
 then

 CIERRE=$(($CIERRE+1))
 FLAG=1

 else

 aux=$(($RANDOM%$(($numPOZO-1))))

 FPC2[$numFPC2]=${FPOZO[$aux]}

 echo "PC2 ha robado: ${FPC2[$numFPC2]} , quedan $(($numPOZO-1)) fichas"

 MOVER_FICHAS_POZO $aux
 jugadasPC2=$(($jugadasPC2-1))

 sacadasPOZO=$(($sacadasPOZO+1))
 numFPC2=$(($numFPC2+1))

 numPOZO=$(($numPOZO-1))
 DIVIDIR_LADOS ${FPC2[$(($numFPC2-1))]}


if [[ $lado1 -eq $IZQ ]]
then
 IZQ=$lado2
 MOVER_FICHAS_PC2 $(($numFPC2-1))
 MOVER_TABLERO_DERECHA
 TABLERO[0]="$lado2$lado1"
 FLAG=1
 jugadasPC2=$(($jugadasPC2+1))
 numFPC2=$(($numFPC2-1))
 CIERRE=0
 numFTABLERO=$(($numFTABLERO+1))

elif [[ $lado2 -eq $IZQ ]]
then
 IZQ=$lado1
 IZQ=$lado1
 MOVER_FICHAS_PC2 $(($numFPC2-1))
 MOVER_TABLERO_DERECHA
 TABLERO[0]="$lado1$lado2"

 FLAG=1
 jugadasPC2=$(($jugadasPC2+1))
 numFPC2=$(($numFPC2-1))
 CIERRE=0
 numFTABLERO=$(($numFTABLERO+1))


elif [[ $lado1 -eq $DER ]]
then
 DER=$lado2
 TABLERO[$(($numFTABLERO))]="$lado1$lado2"
 MOVER_FICHAS_PC2 $(($numFPC2-1))
 FLAG=1
 jugadasPC2=$(($jugadasPC2+1))
 numFTABLERO=$(($numFTABLERO+1))
 numFPC2=$(($numFPC2-1))
 CIERRE=0

elif [[ $lado2 -eq $DER ]]
then
 DER=$lado1
 TABLERO[$(($numFTABLERO))]="$lado2$lado1"
 MOVER_FICHAS_PC2 $(($numFPC2-1))
 FLAG=1
 jugadasPC2=$(($jugadasPC2+1))
 numFTABLERO=$(($numFTABLERO+1))
 numFPC2=$(($numFPC2-1))
 CIERRE=0
fi

fi

done



}

#===================================================
#ROBA DEL POZO JUGADOR PC3==========================
#===================================================

function ROBAR_PC3
{

echo "AHORA VA A ROBAR PC3"

while [[ $FLAG -eq 0 ]]
do

 if [[ $numPOZO -eq 1 ]]
 then

 CIERRE=$(($CIERRE+1))
 FLAG=1

 else

 aux=$(($RANDOM%$(($numPOZO-1))))

 FPC3[$numFPC3]=${FPOZO[$aux]}
 echo "PC3 ha robado: ${FPC3[$numFPC3]} , quedan $(($numPOZO-1)) fichas"

 MOVER_FICHAS_POZO $aux
 jugadasPC3=$(($jugadasPC3-1))

 sacadasPOZO=$(($sacadasPOZO+1))
 numFPC3=$(($numFPC3+1))
 numPOZO=$(($numPOZO-1))

 DIVIDIR_LADOS ${FPC3[$(($numFPC3-1))]}


if [[ $lado1 -eq $IZQ ]]
then
 IZQ=$lado2
 MOVER_FICHAS_PC3 $(($numFPC3-1))
 MOVER_TABLERO_DERECHA
 TABLERO[0]="$lado2$lado1"
 FLAG=1
 jugadasPC3=$(($jugadasPC3+1))
 numFPC3=$(($numFPC3-1))
 CIERRE=0
 numFTABLERO=$(($numFTABLERO+1))

elif [[ $lado2 -eq $IZQ ]]
then
 IZQ=$lado1
 IZQ=$lado1
 MOVER_FICHAS_PC3 $(($numFPC3-1))
 MOVER_TABLERO_DERECHA
 TABLERO[0]="$lado1$lado2"

 FLAG=1
 jugadasPC3=$(($jugadasPC3+1))
 numFPC3=$(($numFPC3-1))
 CIERRE=0
 numFTABLERO=$(($numFTABLERO+1))


elif [[ $lado1 -eq $DER ]]
then
 DER=$lado2
 TABLERO[$(($numFTABLERO))]="$lado1$lado2" MOVER_FICHAS_PC3 $(($numFPC3-1))
 FLAG=1
 jugadasPC3=$(($jugadasPC3+1))
 numFTABLERO=$(($numFTABLERO+1))
 numFPC3=$(($numFPC3-1))
 CIERRE=0

elif [[ $lado2 -eq $DER ]]
then
 DER=$lado1
 TABLERO[$(($numFTABLERO))]="$lado2$lado1"
 MOVER_FICHAS_PC3 $(($numFPC3-1))
 FLAG=1
 jugadasPC3=$(($jugadasPC3+1))
 numFTABLERO=$(($numFTABLERO+1))
 numFPC3=$(($numFPC3-1))
 CIERRE=0
fi
fi
done
}

#===================================================
#ACCIONES QUE PUEDE TOMAR EL JUGADOR JUG============
#===================================================

function JUGAR_JUG
{

echo "ES EL TURNO DE JUG"
SALIDA=0



while [[ $SALIDA -eq 0 ]]
do

 echo -e "Introduzca la ficha que desea introducir :O: PULSE R PARA ROBAR :O: PULSE P PARA PASAR"

 read


 posicion=$REPLY
 if [[ $posicion = 'P' ]]
 then
 SALIDA=1
 break

 fi
 echo -e "Introduzca el lado por el que quiere añadilol: 0 --> IZQUIERDA o 1-->DERCHA | SI NO PUEDE USAR DICHA FICHA PULSE P"
 read

 lado=$REPLY


 if [[ $posicion = 'R' ]] #roba
 then

 ROBAR_JUG

 fi

 if [[ $lado -eq 0 ]]
 then
 DIVIDIR_LADOS ${FJUG[$(($posicion-1))]}
 if [[ $lado1 -eq $IZQ ]] # [5|4] --> [4|6] IZQ=lado2
 then # [4|5] --> [4|6] izq=LADO1
 IZQ=$lado2
 MOVER_TABLERO_DERECHA
 TABLERO[0]="$lado2$lado1"
 MOVER_FICHAS_JUG $(($posicion-1))
 SALIDA=1
 jugadasJUG=$(($jugadasJUG+1))
 numFJUG=$(($numFJUG-1))
 numFTABLERO=$(($numFTABLERO+1))
 CIERRE=0


 elif [[ $lado2 -eq $IZQ ]]
 then


 IZQ=$lado1
 MOVER_TABLERO_DERECHA
 TABLERO[0]=${FJUG[$(($posicion-1))]}
 MOVER_FICHAS_JUG $(($posicion-1))
 SALIDA=1
 jugadasJUG=$(($jugadasJUG+1))
 numFJUG=$(($numFJUG-1))
 numFTABLERO=$(($numFTABLERO+1))
 CIERRE=0

 else
 #SI NO SE PUEDE METER LA FICHA EN ESE LADO
 echo "LA FICHA NO SE PUEDE INTRODUCIR EN EL LADO IZQUIERDO"
 SALIDA=0


 #SE VUELVE A PEDIR OTRA FICHA
 fi
 fi

 if [[ $lado -eq 1 ]] #derecha
 then
 DIVIDIR_LADOS ${FJUG[$posicion-1]}


 if [[ $lado1 -eq $DER ]]
 then
 DER=$lado2
 TABLERO[$numFTABLERO]=${FJUG[$posicion-1]}
 MOVER_FICHAS_JUG $(($posicion-1))
 SALIDA=1
 jugadasJUG=$(($jugadasJUG+1))
 numFTABLERO=$(($numFTABLERO+1))
 numFJUG=$(($numFJUG-1))
 CIERRE=0

 elif [[ $lado2 -eq $DER ]]
 then

 DER=$lado1
 TABLERO[$numFTABLERO]="$lado2$lado1"
 MOVER_FICHAS_JUG $(($posicion-1))
 SALIDA=1
 jugadasJUG=$(($jugadasJUG+1))
 numFTABLERO=$(($numFTABLERO+1))
 numFJUG=$(($numFJUG-1))
 CIERRE=0

 else
 #SI NO SE PUEDE METER EN NINGUN LADO
 echo "LA FICHA NO SE PUEDE INTRODUCIR EN EL LADO DERECHO"
 SALIDA=0

 fi
 fi

done

}
#===================================================
#ACCIONES QUE PUEDE REALIZAR EL BOT PC1=============
#===================================================

function JUGAR_PC1
{

i=0
FLAG=0

echo "ESTE SERIA EL TURNO DE PC1"

while [[ $FLAG -eq 0 ]] && [[ $i -ne $numFPC1 ]]
do
DIVIDIR_LADOS ${FPC1[$i]}

if [[ $lado1 -eq $IZQ ]]
then
 IZQ=$lado2
 MOVER_FICHAS_PC1 $i
 MOVER_TABLERO_DERECHA
 TABLERO[0]="$lado2$lado1"
 FLAG=1
 jugadasPC1=$(($jugadasPC1+1))
 numFPC1=$(($numFPC1-1))
 CIERRE=0
 numFTABLERO=$(($numFTABLERO+1))

elif [[ $lado2 -eq $IZQ ]]
then
 IZQ=$lado1
 MOVER_FICHAS_PC1 $i
 MOVER_TABLERO_DERECHA
 TABLERO[0]="$lado1$lado2"
 FLAG=1
 jugadasPC1=$(($jugadasPC1+1))
 numFPC1=$(($numFPC1-1))
 CIERRE=0
 numFTABLERO=$(($numFTABLERO+1))


elif [[ $lado1 -eq $DER ]]
then
 DER=$lado2
 TABLERO[$(($numFTABLERO))]="$lado1$lado2"
 MOVER_FICHAS_PC1 $i
 FLAG=1
 jugadasPC1=$(($jugadasPC1+1))
 numFTABLERO=$(($numFTABLERO+1))
 numFPC1=$(($numFPC1-1))
 CIERRE=0

elif [[ $lado2 -eq $DER ]]
then
 DER=$lado1
 TABLERO[$(($numFTABLERO))]="$lado2$lado1"
 MOVER_FICHAS_PC1 $i
 FLAG=1
 jugadasPC1=$(($jugadasPC1+1))
 numFTABLERO=$(($numFTABLERO+1))
 numFPC1=$(($numFPC1-1))
 CIERRE=0

fi

i=$(($i+1))

done

if [[ $FLAG -eq 0 ]]
then

ROBAR_PC1

fi
}
#===================================================
#ACCIONES QUE PUEDE REALIZAR EL BOT PC2=============
#===================================================
function JUGAR_PC2
{

i=0
FLAG=0

echo "ESTE SERIA EL TURNO DE PC2"
if [[ $INT -eq 0 ]]
then

while [[ $FLAG -eq 0 ]] && [[ $i -ne $numFPC2 ]]
do
DIVIDIR_LADOS ${FPC2[$i]}

if [[ $lado1 -eq $IZQ ]]
then
 IZQ=$lado2
 MOVER_FICHAS_PC2 $i
 MOVER_TABLERO_DERECHA
 TABLERO[0]="$lado2$lado1"
 FLAG=1
 jugadasPC2=$(($jugadasPC2+1))
 numFPC2=$(($numFPC2-1))
 CIERRE=0
 numFTABLERO=$(($numFTABLERO+1))

elif [[ $lado2 -eq $IZQ ]]
then
 IZQ=$lado1
 MOVER_FICHAS_PC2 $i
 MOVER_TABLERO_DERECHA
 TABLERO[0]="$lado1$lado2"
 FLAG=1
 jugadasPC2=$(($jugadasPC2+1))
 numFPC2=$(($numFPC2-1))
 CIERRE=0
 numFTABLERO=$(($numFTABLERO+1))


elif [[ $lado1 -eq $DER ]]
then
 DER=$lado2
 TABLERO[$(($numFTABLERO))]="$lado1$lado2"
 MOVER_FICHAS_PC2 $i
 FLAG=1
 jugadasPC2=$(($jugadasPC2+1))
 numFTABLERO=$(($numFTABLERO+1))
 numFPC2=$(($numFPC2-1))
 CIERRE=0

elif [[ $lado2 -eq $DER ]]
then
 DER=$lado1
 TABLERO[$(($numFTABLERO))]="$lado2$lado1"
 MOVER_FICHAS_PC2 $i
 FLAG=1
 jugadasPC2=$(($jugadasPC2+1))
 numFTABLERO=$(($numFTABLERO+1))
 numFPC2=$(($numFPC2-1))
 CIERRE=0

fi
i=$(($i+1))


done

if [[ $FLAG -eq 0 ]]
then
ROBAR_PC2

fi
fi
}

#===================================================
#ACCIONES QUE PUEDE REALIZAR EL BOT PC3=============
#===================================================

function JUGAR_PC3
{

i=0
FLAG=0
echo "ESTE SERIA EL TURNO DE PC3"


if [[ $INT -eq 0 ]]
then
while [[ $FLAG -eq 0 ]] && [[ $i -ne $numFPC3 ]]
do
DIVIDIR_LADOS ${FPC3[$i]}
if [[ $lado1 -eq $IZQ ]]
then
 IZQ=$lado2
 MOVER_FICHAS_PC3 $i
 MOVER_TABLERO_DERECHA
 TABLERO[0]="$lado2$lado1"
 FLAG=1
 jugadasPC3=$(($jugadasPC3+1))
 numFPC3=$(($numFPC3-1))
 CIERRE=0
 numFTABLERO=$(($numFTABLERO+1))
elif [[ $lado2 -eq $IZQ ]]
then
 IZQ=$lado1
 MOVER_FICHAS_PC3 $i
 MOVER_TABLERO_DERECHA
 TABLERO[0]="$lado1$lado2"
 MOVER_TABLERO_DERECHA
 TABLERO[0]="$lado1$lado2"
 FLAG=1
 jugadasPC3=$(($jugadasPC3+1))
 numFPC3=$(($numFPC3-1))
 CIERRE=0
 numFTABLERO=$(($numFTABLERO+1))

elif [[ $lado1 -eq $DER ]]
then
 DER=$lado2
 TABLERO[$(($numFTABLERO))]="$lado1$lado2"
 MOVER_FICHAS_PC3 $i
 FLAG=1
 jugadasPC3=$(($jugadasPC3+1))
 numFTABLERO=$(($numFTABLERO+1))
 numFPC3=$(($numFPC3-1))
 CIERRE=0
elif [[ $lado2 -eq $DER ]]
then
 DER=$lado1
 TABLERO[$(($numFTABLERO))]="$lado2$lado1"
 MOVER_FICHAS_PC3 $i
 FLAG=1
 jugadasPC3=$(($jugadasPC3+1))
 numFTABLERO=$(($numFTABLERO+1))
 numFPC3=$(($numFPC3-1))
 CIERRE=0
fi
i=$(($i+1))

done


if [[ $FLAG -eq 0 ]]
then

ROBAR_PC3

fi
fi
}

#===================================================================
#FUNCION QUE MUESTRA LOS PUNTOS QUE RECIBE JUG AL GANAR=============
#===================================================================

function SUMA_PUNTOS_JUG
{
i=0

tempPC1=0
sumaPC1=0
tempPC2=0
sumaPC2=0
tempPC3=0
sumaPC3=0

j=$1 #PC1
k=$2 #PC2
l=$3 #PC3

if [[ $JUG -eq 2 ]]
then
 while [[ $i -lt $j ]]
 do
 DIVIDIR_LADOS ${FPC1[$i]}
 tempPC1=$(($lado1+$lado2))
 sumaPC1=$(($sumaPC1+$tempPC1))
 i=$(($i+1))
 done
 puntosJUG=$sumaPC1
fi

if [[ $JUG -eq 3 ]]
then

 while [[ $i -lt $j ]]
 do
 DIVIDIR_LADOS ${FPC1[$i]}
 tempPC1=$(($lado1+$lado2))
 sumaPC1=$(($sumaPC1+$tempPC1))
 i=$(($i+1))
 done
 i=0
 while [[ $i -lt $k ]]
 do
 DIVIDIR_LADOS ${FPC2[$i]}
 tempPC2=$(($lado1+$lado2))
 sumaPC2=$(($sumaPC2+$tempPC2))
 i=$(($i+1))
 done
 puntosJUG=$(($sumaPC1+$sumaPC2))

fi
if [[ $JUG -eq 4 ]]
then
 while [[ $i -lt $j ]]
 do
 DIVIDIR_LADOS ${FPC1[$i]}
 tempPC1=$(($lado1+$lado2))
 sumaPC1=$(($sumaPC1+$tempPC1))
 i=$(($i+1))
 done
 i=0

 while [[ $i -lt $k ]]
 do
 DIVIDIR_LADOS ${FPC2[$i]}
 tempPC2=$(($lado1+$lado2))
 sumaPC2=$(($sumaPC2+$tempPC2))
 i=$(($i+1))
 done

 i=0

 while [[ $i -lt $l ]]
 do
 DIVIDIR_LADOS ${FPC3[$i]}
 tempPC3=$(($lado1+$lado2))
 sumaPC3=$(($sumaPC3+$tempPC3))
 i=$(($i+1))
 done

 puntosJUG=$(($sumaPC1+$sumaPC2+$sumaPC3))
fi

}

#===================================================================
#FUNCION QUE MUESTRA LOS PUNTOS QUE RECIBE PC1 AL GANAR=============
#===================================================================

function SUMA_PUNTOS_PC1
{
i=0
tempPC2=0
sumaPC2=0
tempJUG=0
sumaJUG=0
tempPC3=0
sumaPC3=0
j=$1 #JUG
k=$2 #PC2
l=$3 #PC3

if [[ $JUG -eq 2 ]]
then

 while [[ $i -lt $j ]]
 do
 DIVIDIR_LADOS ${FJUG[$i]}
 tempJUG=$(($lado1+$lado2))
 sumaJUG=$(($sumaJUG+$tempJUG))
 i=$(($i+1))
 done
 puntosPC1=$sumaJUG
fi


if [[ $JUG -eq 3 ]]
then

 while [[ $i -lt $j ]]
 do
 DIVIDIR_LADOS ${FJUG[$i]}
 tempJUG=$(($lado1+$lado2))
 sumaJUG=$(($sumaJUG+$tempJUG))
 i=$(($i+1))
 done

 i=0

 while [[ $i -lt $k ]]
 do
 DIVIDIR_LADOS ${FPC2[$i]}
 tempPC2=$(($lado1+$lado2))
 sumaPC2=$(($sumaPC2+$tempPC2))
 i=$(($i+1))
 done
 puntosPC1=$(($sumaJUG+$sumaPC2))

fi
if [[ $JUG -eq 4 ]]
then
 while [[ $i -lt $j ]]
 do
 DIVIDIR_LADOS ${FJUG[$i]}
 tempJUG=$(($lado1+$lado2))
 sumaJUG=$(($sumaJUG+$tempJUG))
 i=$(($i+1))
 done

 i=0

 while [[ $i -lt $k ]]
 do
 DIVIDIR_LADOS ${FPC2[$i]}
 tempPC2=$(($lado1+$lado2))
 sumaPC2=$(($sumaPC2+$tempPC2))
 i=$(($i+1))
 done

 i=0
 while [[ $i -lt $l ]]
 do
 DIVIDIR_LADOS ${FPC3[$i]}
 tempPC3=$(($lado1+$lado2))
 sumaPC3=$(($sumaPC3+$tempPC3))
 i=$(($i+1))
 done

 puntosPC1=$(($sumaJUG+$sumaPC2+$sumaPC3))

fi
}

#===================================================================
#FUNCION QUE MUESTRA LOS PUNTOS QUE RECIBE PC2 AL GANAR=============
#===================================================================

function SUMA_PUNTOS_PC2
{
i=0
tempJUG=0
sumaJUG=0
tempPC1=0
sumaPC1=0
tempPC3=0
sumaPC3=0
j=$1 #pc1
k=$2 #jug
l=$3 #pc3

if [[ $JUG -eq 3 ]]
then

 while [[ $i -lt $j ]]
 do
 DIVIDIR_LADOS ${FPC1[$i]}
 tempPC1=$(($lado1+$lado2))
 sumaPC1=$(($sumaPC1+$tempPC1))
 i=$(($i+1))
 done

 i=0

 while [[ $i -lt $k ]]
 do
 DIVIDIR_LADOS ${FJUG[$i]}
 tempJUG=$(($lado1+$lado2))
 sumaJUG=$(($sumaJUG+$tempJUG))
 i=$(($i+1))
 done

 puntosPC2=$(($sumaJUG+$sumaPC1))
fi

if [[ $JUG -eq 4 ]]
then

 while [[ $i -lt $j ]]
 do
 DIVIDIR_LADOS ${FPC1[$i]}
 tempPC1=$(($lado1+$lado2))
 sumaPC1=$(($sumaPC1+$tempPC1))
 i=$(($i+1))
 done
 i=0

 while [[ $i -lt $k ]]
 do
 DIVIDIR_LADOS ${FJUG[$i]}
 tempJUG=$(($lado1+$lado2))
 sumaJUG=$(($sumaJUG+$tempJUG))
 i=$(($i+1))
 done
 i=0
 while [[ $i -lt $l ]]
 do
 DIVIDIR_LADOS ${FPC3[$i]}
 tempPC3=$(($lado1+$lado2))
 sumaPC3=$(($sumaPC3+$tempPC3))
 i=$(($i+1))
 done

 puntosPC2=$(($sumaPC1+$sumaJUG+$sumaPC3))

fi

}

#===================================================================
#FUNCION QUE MUESTRA LOS PUNTOS QUE RECIBE PC3 AL GANAR=============
#===================================================================

function SUMA_PUNTOS_PC3
{
i=0
tempPC1=0
sumaPC1=0
tempJUG=0
sumaJUG=0
tempPC2=0
sumaPC2=0
j=$1 #PC1
k=$2 #PC2
l=$3 #JUG

 while [[ $i -lt $j ]]
 do
 DIVIDIR_LADOS ${FPC1[$i]}
 tempPC1=$(($lado1+$lado2))
 sumaPC1=$(($sumaPC1+$tempPC1))
 i=$(($i+1))
 done
 i=0

 while [[ $i -lt $k ]]
 do
 DIVIDIR_LADOS ${FPC2[$i]}
 tempPC2=$(($lado1+$lado2))
 sumaPC2=$(($sumaPC2+$tempPC2))
 i=$(($i+1))
 done

 i=0

 while [[ $i -lt $l ]]
 do
 DIVIDIR_LADOS ${FJUG[$i]}
 tempJUG=$(($lado1+$lado2))
 sumaJUG=$(($sumaJUG+$tempJUG))
 i=$(($i+1))
 done

 puntosPC3=$(($sumaPC1+$sumaPC2+$sumaJUG))

}
#===================================================================
#INTERFAZ DEL TABLERO PARA 2 JUGADORES==============================
#===================================================================

function VER_MESA
{
 echo -e "##############################################"
 echo -e "RONDA: $1"
 echo -e "##############################################"
 echo -e "TABLERO DE JUEGO: ${TABLERO[@]}"
 echo -e "=============================================="
 echo -e "FICHAS DE JUG: ${FJUG[@]} "
 echo -e "=============================================="
 echo -e "FICHAS DE PC1: ${FPC1[@]}"
 echo -e "=============================================="

 echo -e "FICHAS SACADAS POR JUG: $jugadasJUG"
 echo -e "FICHAS SACADAS POR PC1: $jugadasPC1"

 echo -e "PUNTOS JUG= $ptsJUG "
 echo -e "PUNTOS PC1= $ptsPC1 "
}

#===================================================================
#INTERFAZ DEL TABLERO PARA 4 JUGADORES==============================
#===================================================================

function VER_MESA_4
{


 echo -e "##############################################"
 echo -e "RONDA: $1"
 echo -e "##############################################"
 echo -e "TABLERO DE JUEGO: ${TABLERO[@]}"
 echo -e "=============================================="
 echo -e "FICHAS DE JUG: ${FJUG[@]} "
 echo -e "=============================================="
 echo -e "FICHAS DE PC1: ${FPC1[@]}"
 echo -e "=============================================="
 echo -e "FICHAS DE PC2: ${FPC2[@]} "
 echo -e "=============================================="
 echo -e "FICHAS DE PC3: ${FPC3[@]}"
 echo -e "=============================================="
 echo -e "FICHAS SACADAS POR JUG: $jugadasJUG"
 echo -e "FICHAS SACADAS POR PC1: $jugadasPC1"
 echo -e "FICHAS SACADAS POR PC2: $jugadasPC2"
 echo -e "FICHAS SACADAS POR PC3: $jugadasPC3"
 echo -e "PUNTOS JUG= $ptsJUG "
 echo -e "PUNTOS PC1= $ptsPC1 "
 echo -e "PUNTOS PC2= $ptsPC2 "
 echo -e "PUNTOS PC3= $ptsPC3 "



}

#===================================================================
#INTERFAZ DEL TABLERO PARA 3 JUGADORES==============================
#===================================================================

function VER_MESA_3
{

 echo -e "##############################################"
 echo -e "RONDA: $1"
 echo -e "##############################################"
 echo -e "TABLERO DE JUEGO: ${TABLERO[@]}"
 echo -e "=============================================="
 echo -e "FICHAS DE JUG: ${FJUG[@]} "
 echo -e "=============================================="
 echo -e "FICHAS DE PC1: ${FPC1[@]}"
 echo -e "=============================================="
 echo -e "FICHAS DE PC2: ${FPC2[@]} "
 echo -e "=============================================="


 echo -e "FICHAS SACADAS POR JUG: $jugadasJUG"
 echo -e "FICHAS SACADAS POR PC1: $jugadasPC1"
 echo -e "FICHAS SACADAS POR PC2: $jugadasPC2"


 echo -e "PUNTOS JUG= $ptsJUG "
 echo -e "PUNTOS PC1= $ptsPC1 "
 echo -e "PUNTOS PC2= $ptsPC2 "




}


#===================================================================
#PARTIDA PARA 2 JUGADORES===========================================
#===================================================================

function PARTIDA_2
{

declare -a TABLERO


IZQ=0 #EXTREMO IZQUIERDO
DER=0 #EXTREMO DERECHO
 #INCREMENTA 1 CADA VEZ QUE JUG SUELTA 1 Y DECREMENTA 1 CADA VEZ
numPOZO=14

ELEGIR_TURNO_2

if [[ $turno -eq 0 ]] #EMPIEZA JUG
then
 echo "COMIENZA JUG"
 echo $numFJUG
 TABLERO[0]=$RESUL_TURNO
 numFTABLERO=$(($numFTABLERO+1))
 jugadasJUG=1
#CALCULAMOS LA POSICION DE LA PRIMERA FICHA PARA SACARLA DEL VECTOR

i=0

 while [[ $i -lt 7 ]]

 do

 if [[ ${FJUG[$i]} -eq $RESUL_TURNO ]]
 then

 pos=$i

 fi

 i=$(($i+1))

 done

 MOVER_FICHAS_JUG $pos

 DIVIDIR_LADOS $RESUL_TURNO
 IZQ=$lado1
 DER=$lado2
 RONDA=1

 #CORRESPONDIENTE A LA FICHA DE JUG RESUL TURNO
 while [[ $FIN -ne 1 ]]
 do

 VER_MESA $RONDA
 if [[ $INT -eq 0 ]]
 then
 JUGAR_PC1 #FUCNION PARA QUE JUEGUE EL BOT 1 Y QUE BUSQUE LA FICHA QUE PUEDE INTRODUCIR Y COMPROBANFO QUE LA PUEDE USAR, Y SI PUEDE SACAR Y SACA LA FICHA
INCREMENTA JUGADASPC1

 elif [[ $INT -eq 1 ]]
 then
 it1=1
 it2=$(($numFPC1-1))

 auxiliar=0
 while [[ $it1 -lt $(($numFPC1-1)) ]]
 do
 while [[ $it2 -lt $it1 ]]
 do

 if [[ ${FPC1[$it2]} -lt ${FPC1[$(($it2+1))]} ]]
then

 auxiliar=${FPC1[$it2]}

 FPC1[$it2]=${FPC1[$(($it2+1))]}

 FPC1[$(($it2+1))]=$auxiliar


 fi

 it2=$(($it2-1))
 done

 it1=$(($it1+1))
 done
 JUGAR_PC1

 fi

 if [[ jugadasPC1 -eq 7 ]]
 then

 FIN=1
 echo "HA GANADO PC1"

 #SUMA DE SUS PUNTOS

 SUMA_PUNTOS_PC1 $((7-$jugadasJUG))
 ptsPC1=$(($ptsPC1+$puntosPC1))
 echo "PUNTOS PC1= $ptsPC1 "
 sleep 5
 break
 fi


 VER_MESA $RONDA

 JUGAR_JUG #FUCNION PARA QUE JUEGUE EL JUG Y QUE BUSQUE LA FICHA QUE PUEDE INTRODUCIR Y COMPROBANFO QUE LA PUEDE USAR, Y SI PUEDE SACAR Y SACA LA FICHA INCREMENTA
JUGADASJUG



 if [[ $jugadasJUG -eq 7 ]]
 then

 echo "HA GANADO JUG"
 FIN=1
 SUMA_PUNTOS_JUG $((7-$jugadasPC1))
 ptsJUG=$(($ptsJUG+$puntosJUG))
 echo "PUNTOS JUG= $ptsJUG "
 sleep 5
 break

 fi

 if [[ $CIERRE -ge 2 ]]
 then

 echo "LA PARTIDA ESTA CERRADA"

 #CALCULA A QUIEN LE DA LOS PUNTOS


 echo "LA PARTIDA ESTA CERRADA"
 #CALCULA A QUIEN LE DA LOS PUNTOS

 puntosCIERREJUG=0
 puntosCIERREPC1=0

 i=0

 while [[ $i -lt $numFJUG ]]
 do

 DIVIDIR_LADOS {$numFJUG[$i]}
 puntosCIERREJUG=$(($puntosCIERREJUG+$lado1+$lado2))

 done

 i=0

 while [[ $i -lt $numFPC1 ]]
 do

 DIVIDIR_LADOS {$numFPC1[$i]}

 puntosCIERREPC1=$(($puntosCIERREPC1+$lado1+$lado2))

 done

 if [[ $puntosCIERREJUG -lt $puntosCIERREPC1 ]]
 then

 puntosJUG=$puntosCIERREPC1
 echo "PUNTOS JUG : $puntosJUG "

 elif [[ $puntosCIERREPC1 -lt $puntosCIERREJUG ]]
 then
 puntosPC1=$puntosCIERREJUG
 echo "PUNTOS PC1 : $puntosPC1 "

 fi

 FIN=1
 break

 fi

 RONDA=$(($RONDA+1))
 done



elif [[ $turno -eq 1 ]] #EMPIEZA PC1
then
 echo "COMIENZA PC1"
 echo "$numFPC1"
 TABLERO[0]=$RESUL_TURNO
 numFTABLERO=$(($numFTABLERO+1))
 jugadasPC1=1
#CALCULAMOS LA POSICION DE LA PRIMERA FICHA PARA SACARLA DEL VECTOR
j=0
 while test $j -lt 7
 do

 if [[ ${FPC1[$j]} -eq $RESUL_TURNO ]]
 then

 pos=$j
 fi

 j=$(($j+1))

 done

 MOVER_FICHAS_PC1 $pos




 DIVIDIR_LADOS $RESUL_TURNO
 IZQ=$lado1
 DER=$lado2

 RONDA=1

 #CORRESPONDIENTE A LA FICHA DE PC1 RESUL TURNO

 while [[ $FIN -ne 1 ]]
 do


 VER_MESA $RONDA

 JUGAR_JUG #FUCNION PARA QUE JUEGUE EL BOT 1 Y QUE BUSQUE LA FICHA QUE PUEDE INTRODUCIR Y COMPROBANFO QUE LA PUEDE USAR, Y SI PUEDE SACAR Y SACA LA FICHA
INCREMENTA JUGADASPC1

 if [[ jugadasJUG -eq 7 ]]
 then
 FIN=1

 echo "HA GANADO JUG"
 SUMA_PUNTOS_JUG $((7-$jugadasPC1))
 ptsJUG=$(($ptsJUG+$puntosJUG))
 echo "PUNTOS JUG= $ptsJUG "
 sleep 5
 FIN=1
 break

 fi

 VER_MESA $RONDA
 if [[ $INT -eq 0 ]]
 then
 JUGAR_PC1 #FUCNION PARA QUE JUEGUE EL JUG Y QUE BUSQUE LA FICHA QUE PUEDE INTRODUCIR Y COMPROBANFO QUE LA PUEDE USAR, Y SI PUEDE SACAR Y SACA LA FICHA INCREMENTA
JUGADASJUG

 elif [[ $INT -eq 1 ]]
 then
 it1=1
 it2=$(($numFPC1-1))

 auxiliar=0
 while [[ $it1 -lt $(($numFPC1-1)) ]]
 do

 while [[ $it2 -lt $it1 ]]
 do

 if [[ ${FPC1[$it2]} -lt ${FPC1[$(($it2+1))]} ]]
then

 auxiliar=${FPC1[$it2]}

 FPC1[$it2]=${FPC1[$(($it2+1))]}

 FPC1[$(($it2+1))]=$auxiliar


 fi

 it2=$(($it2-1))
 done

 it1=$(($it1+1))
 done
 JUGAR_PC1

 fi



 if [[ $jugadasPC1 -eq 7 ]]
 then

 echo "HA GANADO PC1"
 SUMA_PUNTOS_PC1 $((7-$jugadasJUG))
 ptsPC1=$(($ptsPC1+$puntosPC1))
 echo "PUNTOS PC1= $ptsPC1 "
 sleep 5
 FIN=1
 break

 fi
 if [[ $CIERRE -eq 2 ]]
 then


 echo "LA PARTIDA ESTA CERRADA"

 #CALCULA A QUIEN LE DA LOS PUNTOS

 puntosCIERREJUG=0
 puntosCIERREPC1=0

 i=0

 while [[ $i -lt $numFJUG ]]
 do

 DIVIDIR_LADOS {$numFJUG[$i]}

 puntosCIERREJUG=$(($puntosCIERREJUG+$lado1+$lado2))

 done

 i=0

 while [[ $i -lt $numFPC1 ]]
 do

 DIVIDIR_LADOS {$numFPC1[$i]}

 puntosCIERREPC1=$(($puntosCIERREPC1+$lado1+$lado2))

 done

 if [[ $puntosCIERREJUG -lt $puntosCIERREPC1 ]]
 then

 puntosJUG=$puntosCIERREPC1
 echo "PUNTOS JUG : $puntosJUG "

 elif [[ $puntosCIERREPC1 -lt $puntosCIERREJUG ]]
 then
 puntosPC1=$puntosCIERREJUG
 echo "PUNTOS PC1 : $puntosPC1 "
 fi






 FIN=1
 break

 fi

 done

 RONDA=$(($RONDA+1))


fi


}

#===================================================================
#PARTIDA PARA3 JUGADORES===========================================
#===================================================================


function PARTIDA_3
{

declare -a TABLERO

FIN=0
IZQ=0 #EXTREMO IZQUIERDO
DER=0 #EXTREMO DERECHO

numPOZO=7


ELEGIR_TURNO_3
if [[ $turno -eq 0 ]] #EMPIEZA JUG
then
 echo "COMIENZA JUG"

 TABLERO[0]=$RESUL_TURNO
 jugadasJUG=1
#CALCULAMOS LA POSICION DE LA PRIMERA FICHA PARA SACARLA DEL VECTOR

i=0

 while [[ $i -lt 7 ]]
 do

 if [[ ${FJUG[$i]} -eq $RESUL_TURNO ]]
 then

 pos=$i

 fi

 i=$(($i+1))

 done

 MOVER_FICHAS_JUG $pos

 DIVIDIR_LADOS $RESUL_TURNO
 IZQ=$lado1
 DER=$lado2

 RONDA=1
 #CORRESPONDIENTE A LA FICHA DE JUG RESUL TURNO
 until [[ $FIN -eq 1 ]]
 do

 VER_MESA_3 $RONDA
 echo "TURNO DE PC1: "
 JUGAR_PC1 #FUCNION PARA QUE JUEGUE EL BOT 1 Y QUE BUSQUE LA FICHA QUE PUEDE INTRODUCIR Y COMPROBANFO QUE LA PUEDE USAR, Y SI PUEDE SACAR Y SACA LA FICHA
INCREMENTA JUGADASPC1
 if [[ jugadasPC1 -eq 7 ]]
 then
 echo "HA GANADO PC1"
 #SUMA DE SUS PUNTOS

 SUMA_PUNTOS_PC1 $((7-$jugadasJUG)) $((7-$jugadasPC2))
 ptsPC1=$(($ptsPC1+$puntosPC1))
 echo "PUNTOS PC1= $ptsPC1 "
 sleep 5
 FIN=1
 break

 fi


 VER_MESA_3 $RONDA

 echo "TURNO DE PC2: "
 JUGAR_PC2 #FUCNION PARA QUE JUEGUE EL BOT 2 Y QUE BUSQUE LA FICHA QUE PUEDE INTRODUCIR Y COMPROBANFO QUE LA PUEDE USAR, Y SI PUEDE SACAR Y SACA LA FICHA
INCREMENTA JUGADASPC1

 if [[ jugadasPC2 -eq 7 ]]
 then


 echo "HA GANADO PC2"

 SUMA_PUNTOS_PC2 $((7-$jugadasPC1)) $((7-$jugadasJUG))
 ptsPC2=$(($ptsPC2+$puntosPC2))
 echo "PUNTOS PC2= $ptsPC2 "

 sleep 5
 FIN=1
 break
 fi



 VER_MESA_3 $RONDA
 echo "TURNO DE JUG: "
 JUGAR_JUG #FUCNION PARA QUE JUEGUE EL JUG Y QUE BUSQUE LA FICHA QUE PUEDE INTRODUCIR Y COMPROBANFO QUE LA PUEDE USAR, Y SI PUEDE SACAR Y SACA LA FICHA INCREMENTA
JUGADASJUG


 if [[ $jugadasJUG -eq 7 ]]
 then
 FIN=1
 echo "HA GANADO JUG"

 SUMA_PUNTOS_JUG $((7-$jugadasPC1)) $((7-$jugadasPC2))
 ptsJUG=$(($ptsJUG+$puntosJUG))
 echo "PUNTOS JUG= $ptsJUG "

 sleep 5
 FIN=1
 break

 fi



 if [[ $CIERRE -ge 3 ]]
 then

 #CALCULA A QUIEN LE DA LOS PUNTOS


 echo "LA PARTIDA ESTA CERRADA"

 #CALCULA A QUIEN LE DA LOS PUNTOS

 puntosCIERREJUG=0
 puntosCIERREPC1=0
 puntosCIERREPC2=0
 i=0

 while [[ $i -lt $numFJUG ]]
 do

 DIVIDIR_LADOS {$numFJUG[$i]}

 puntosCIERREJUG=$(($puntosCIERREJUG+$lado1+$lado2))

 done

 i=0

 while [[ $i -lt $numFPC1 ]]
 do

 DIVIDIR_LADOS {$numFPC1[$i]}
 puntosCIERREPC1=$(($puntosCIERREPC1+$lado1+$lado2))
 done

 i=0

 while [[ $i -lt $numFPC2 ]]
 do

 DIVIDIR_LADOS {$numFPC2[$i]}

 puntosCIERREPC2=$(($puntosCIERREPC2+$lado1+$lado2))

 done



 if [[ $puntosCIERREJUG -lt $puntosCIERREPC1 ]] && [[ $puntosCIERREJUG -lt $puntosCIERREPC2 ]]
 then

 puntosJUG=$(($puntosCIERREPC1+$puntosCIERREPC2))
 echo "PUNTOS JUG : $puntosJUG "

 elif [[ $puntosCIERREPC1 -lt $puntosCIERREJUG ]] && [[ $puntosCIERREPC1 -lt $puntosCIERREPC2 ]]

 then
 puntosPC1=$(($puntosCIERREJUG+$puntosCIERREPC2))
 echo "PUNTOS PC1 : $puntosPC1 "



 elif [[ $puntosCIERREPC2 -lt $puntosCIERREJUG ]] && [[ $puntosCIERREPC2 -lt $puntosCIERREPC1 ]]

 then
 puntosPC2=$(($puntosCIERREJUG+$puntosCIERREPC1))
 echo "PUNTOS PC2 : $puntosPC2 "

 fi


 FIN=1

 break

 fi
 RONDA=$(($RONDA+1))

 done


elif [[ $turno -eq 1 ]] #EMPIEZA PC1
then
 echo "COMIENZA PC1"

 TABLERO[0]=$RESUL_TURNO
 jugadasPC1=1

#CALCULAMOS LA POSICION DE LA PRIMERA FICHA PARA SACARLA DEL VECTOR

j=0
 while test $j -lt 7
 do

 if [[ ${FPC1[$j]} -eq $RESUL_TURNO ]]
 then

 pos=$j

 fi

 j=$(($j+1))
 done


 MOVER_FICHAS_PC1 $pos

 DIVIDIR_LADOS $RESUL_TURNO
 IZQ=$lado1
 DER=$lado2

 RONDA=1
 #CORRESPONDIENTE A LA FICHA DE PC1 RESUL TURNO
 until [[ $FIN -eq 1 ]]
 do


 VER_MESA_3 $RONDA
 echo "TURNO DE PC2"
 JUGAR_PC2 #FUCNION PARA QUE JUEGUE EL BOT 1 Y QUE BUSQUE LA FICHA QUE PUEDE INTRODUCIR Y COMPROBANFO QUE LA PUEDE USAR, Y SI PUEDE SACAR Y SACA LA FICHA
INCREMENTA JUGADASPC1

 if [[ jugadasPC2 -eq 7 ]]
 then
 echo "HA GANADO PC2"

 SUMA_PUNTOS_PC2 $((7-$jugadasPC1)) $((7-$jugadasJUG))
 ptsPC2=$(($ptsPC2+$puntosPC2))
 echo "PUNTOS PC2= $ptsPC2 "
 sleep 5
 FIN=1
 break

 fi



 VER_MESA_3 $RONDA

 echo "TURNO DE JUG"

 JUGAR_JUG #FUCNION PARA QUE JUEGUE EL BOT 1 Y QUE BUSQUE LA FICHA QUE PUEDE INTRODUCIR Y COMPROBANFO QUE LA PUEDE USAR, Y SI PUEDE SACAR Y SACA LA FICHA
INCREMENTA JUGADASPC1
 if [[ jugadasJUG -eq 7 ]]
 then


 echo "HA GANADO JUG"
 SUMA_PUNTOS_JUG $((7-$jugadasPC1)) $((7-$jugadasPC2))
 ptsJUG=$(($ptsJUG+$puntosJUG))
 echo "PUNTOS JUG= $ptsJUG "

 sleep 5
 FIN=1
 break
 fi

 VER_MESA_3 $RONDA

 echo "TURNO DE PC1"
 JUGAR_PC1

 if [[ $jugadasPC1 -eq 7 ]]
 then

 FIN=1
 echo "HA GANADO PC1"

 SUMA_PUNTOS_PC1 $((7-$jugadasJUG)) $((7-$jugadasPC2))
 ptsPC1=$(($ptsPC1+$puntosPC1))
 echo "PUNTOS PC1= $ptsPC1 "

 sleep 5
 FIN=1
 break

 fi

 if [[ $CIERRE -ge 3 ]]
 then
 echo "LA PARTIDA ESTA CERRADA"

 #CALCULA A QUIEN LE DA LOS PUNTOS

 puntosCIERREJUG=0
 puntosCIERREPC1=0
 puntosCIERREPC2=0
 i=0

 while [[ $i -lt $numFJUG ]]
 do

 DIVIDIR_LADOS {$numFJUG[$i]}

 puntosCIERREJUG=$(($puntosCIERREJUG+$lado1+$lado2))

 done

 i=0

 while [[ $i -lt $numFPC1 ]]
 do

 DIVIDIR_LADOS {$numFPC1[$i]}

 puntosCIERREPC1=$(($puntosCIERREPC1+$lado1+$lado2))
 done
 i=0

 while [[ $i -lt $numFPC2 ]]
 do
 DIVIDIR_LADOS {$numFPC2[$i]}

 puntosCIERREPC2=$(($puntosCIERREPC2+$lado1+$lado2))

 done


 if [[ $puntosCIERREJUG -lt $puntosCIERREPC1 ]] && [[ $puntosCIERREJUG -lt $puntosCIERREPC2 ]]
 then

 puntosJUG=$(($puntosCIERREPC1+$puntosCIERREPC2))
 echo "PUNTOS JUG : $puntosJUG "

 elif [[ $puntosCIERREPC1 -lt $puntosCIERREJUG ]] && [[ $puntosCIERREPC1 -lt $puntosCIERREPC2 ]]

 then
 puntosPC1=$(($puntosCIERREJUG+$puntosCIERREPC2))
 echo "PUNTOS PC1 : $puntosPC1 "


 elif [[ $puntosCIERREPC2 -lt $puntosCIERREJUG ]] && [[ $puntosCIERREPC2 -lt $puntosCIERREPC1 ]]

 then
 puntosPC2=$(($puntosCIERREJUG+$puntosCIERREPC1))
 echo "PUNTOS PC2 : $puntosPC2 "

 fi




 FIN=1
 break
 fi

 RONDA=$(($RONDA+1))

 done

elif [[ $turno -eq 2 ]] #EMPIEZA PC2
then
 echo "COMIENZA PC2"

 TABLERO[0]=$RESUL_TURNO
 jugadasPC2=1

#CALCULAMOS LA POSICION DE LA PRIMERA FICHA PARA SACARLA DEL VECTOR

k=0
 while test $k -lt 7
 do
 if [[ ${FPC2[$k]} -eq $RESUL_TURNO ]]
 then

 pos=$k

 fi

 k=$(($k+1))

 done


 MOVER_FICHAS_PC2 $pos



 DIVIDIR_LADOS $RESUL_TURNO
 IZQ=$lado1
 DER=$lado2

 RONDA=1

 #CORRESPONDIENTE A LA FICHA DE PC2 RESUL TURNO

 until [[ $FIN -eq 1 ]]
 do


 VER_MESA_3 $RONDA

 echo "TURNO DE JUG"
 JUGAR_JUG #FUCNION PARA QUE JUEGUE EL BOT 1 Y QUE BUSQUE LA FICHA QUE PUEDE INTRODUCIR Y COMPROBANFO QUE LA PUEDE USAR, Y SI PUEDE SACAR Y SACA LA FICHA INCREMENTA
JUGADASPC1
 if [[ jugadasJUG -eq 7 ]]
 then


 echo "HA GANADO JUG"
 SUMA_PUNTOS_JUG $((7-$jugadasPC1)) $((7-$jugadasPC2))
 ptsJUG=$(($ptsJUG+$puntosJUG))
 echo "PUNTOS JUG= $ptsJUG "

 sleep 5
 FIN=1
 break
 fi
 VER_MESA_3 $RONDA

 echo "TRUNO DE PC1"

 JUGAR_PC1 #FUCNION PARA QUE JUEGUE EL BOT 1 Y QUE BUSQUE LA FICHA QUE PUEDE INTRODUCIR Y COMPROBANFO QUE LA PUEDE USAR, Y SI PUEDE SACAR Y SACA LA FICHA
INCREMENTA JUGADASPC1

 if [[ jugadasPC1 -eq 7 ]]
 then


 echo "HA GANADO PC1"

 SUMA_PUNTOS_PC1 $((7-$jugadasJUG)) $((7-$jugadasPC2))
 ptsPC1=$(($ptsPC1+$puntosPC1))
 echo "PUNTOS PC1= $ptsPC1 "

 sleep 5
 FIN=1
 break
 fi
 VER_MESA_3 $RONDA

 echo "TURNO DE PC2"

 JUGAR_PC2 #FUCNION PARA QUE JUEGUE EL JUG Y QUE BUSQUE LA FICHA QUE PUEDE INTRODUCIR Y COMPROBANFO QUE LA PUEDE USAR, Y SI PUEDE SACAR Y SACA LA FICHA INCREMENTA
JUGADASJUG
 if [[ $jugadasPC2 -eq 7 ]]
 then


 echo "HA GANADO PC2"

 SUMA_PUNTOS_PC2 $((7-$jugadasPC1)) $((7-$jugadasJUG))

 ptsPC2=$(($ptsPC2+$puntosPC2))
 echo "PUNTOS PC2= $ptsPC2 "

 sleep 5
 FIN=1

 break
 fi


 if [[ $CIERRE -ge 3 ]]
 then

 echo "LA PARTIDA ESTA CERRADA"

 #CALCULA A QUIEN LE DA LOS PUNTOS

 puntosCIERREJUG=0
 puntosCIERREPC1=0
 puntosCIERREPC2=0
 i=0

 while [[ $i -lt $numFJUG ]]
 do

 DIVIDIR_LADOS {$numFJUG[$i]}

 puntosCIERREJUG=$(($puntosCIERREJUG+$lado1+$lado2))

 done

 i=0

 while [[ $i -lt $numFPC1 ]]
 do

 DIVIDIR_LADOS {$numFPC1[$i]}
 puntosCIERREPC1=$(($puntosCIERREPC1+$lado1+$lado2))
 done

 i=0

 while [[ $i -lt $numFPC2 ]]
 do
 DIVIDIR_LADOS {$numFPC2[$i]}

 puntosCIERREPC2=$(($puntosCIERREPC2+$lado1+$lado2))

 done



 if [[ $puntosCIERREJUG -lt $puntosCIERREPC1 ]] && [[ $puntosCIERREJUG -lt $puntosCIERREPC2 ]]
 then

 puntosJUG=$(($puntosCIERREPC1+$puntosCIERREPC2))
 echo "PUNTOS JUG : $puntosJUG "

 elif [[ $puntosCIERREPC1 -lt $puntosCIERREJUG ]] && [[ $puntosCIERREPC1 -lt $puntosCIERREPC2 ]]

 then
 puntosPC1=$(($puntosCIERREJUG+$puntosCIERREPC2))
 echo "PUNTOS PC1 : $puntosPC1 "



 elif [[ $puntosCIERREPC2 -lt $puntosCIERREJUG ]] && [[ $puntosCIERREPC2 -lt $puntosCIERREPC1 ]]
 then
 puntosPC2=$(($puntosCIERREJUG+$puntosCIERREPC1))
 echo "PUNTOS PC2 : $puntosPC2 "

 fi

 FIN=1
 break
 fi

 RONDA=$(($RONDA+1))

 done

fi
}

#===================================================================
#INTERFAZ DEL TABLERO PARA 4 JUGADORES==============================
#===================================================================

 function PARTIDA_4
{

declare -a TABLERO

IZQ=0 #EXTREMO IZQUIERDO
DER=0 #EXTREMO DERECHO


numPOZO=1


ELEGIR_TURNO_4

if [[ $turno -eq 0 ]] #EMPIEZA JUG
then
 echo "COMIENZA JUG"

 TABLERO[0]=$RESUL_TURNO
 jugadasJUG=1

#CALCULAMOS LA POSICION DE LA PRIMERA FICHA PARA SACARLA DEL VECTOR

i=0

 while [[ $i -lt 7 ]]
 do

 if [[ ${FJUG[$i]} -eq $RESUL_TURNO ]]
 then
 pos=$i
 fi

 i=$(($i+1))

 done
 MOVER_FICHAS_JUG $pos

 DIVIDIR_LADOS $RESUL_TURNO
 IZQ=$lado1
 DER=$lado2
 RONDA=1
 #CORRESPONDIENTE A LA FICHA DE JUG RESUL TURNO
 until [[ $FIN -eq 1 ]]
 do

 VER_MESA_4 $RONDA
 echo "TURNO DE PC1: "

 JUGAR_PC1 #FUCNION PARA QUE JUEGUE EL BOT 1 Y QUE BUSQUE LA FICHA QUE PUEDE INTRODUCIR Y COMPROBANFO QUE LA PUEDE USAR, Y SI PUEDE SACAR Y SACA LA FICHA
INCREMENTA JUGADASPC1
 if [[ jugadasPC1 -eq 7 ]]
 then
 echo "HA GANADO PC1"
 #SUMA DE SUS PUNTOS

 SUMA_PUNTOS_PC1 $((7-$jugadasJUG)) $((7-$jugadasPC2)) $((7-$jugadasPC3))
 ptsPC1=$(($ptsPC1+$puntosPC1))
 echo "PUNTOS PC1= $ptsPC1 "
 sleep 5
 FIN=1
 break

 fi


 VER_MESA_4 $RONDA

 echo "TURNO DE PC2: "
 JUGAR_PC2 #FUCNION PARA QUE JUEGUE EL BOT 2 Y QUE BUSQUE LA FICHA QUE PUEDE INTRODUCIR Y COMPROBANFO QUE LA PUEDE USAR, Y SI PUEDE SACAR Y SACA LA FICHA
INCREMENTA JUGADASPC1
 if [[ jugadasPC2 -eq 7 ]]
 then


 echo "HA GANADO PC2"
 SUMA_PUNTOS_PC2 $((7-$jugadasPC1)) $((7-$jugadasJUG)) $((7-$jugadasPC3))
 ptsPC2=$(($ptsPC2+$puntosPC2))
 echo "PUNTOS PC2= $ptsPC2 "

 sleep 5
 FIN=1
 break
 fi

 VER_MESA_4 $RONDA

 echo "TURNO DE PC3: "
 JUGAR_PC3 #FUCNION PARA QUE JUEGUE EL BOT 3 Y QUE BUSQUE LA FICHA QUE PUEDE INTRODUCIR Y COMPROBANFO QUE LA PUEDE USAR, Y SI PUEDE SACAR Y SACA LA FICHA
INCREMENTA JUGADASPC1

 if [[ jugadasPC3 -eq 7 ]]
 then

 echo "HA GANADO PC3"
 SUMA_PUNTOS_PC3 $((7-$jugadasPC1)) $((7-$jugadasPC2)) $((7-$jugadasJUG))
 ptsPC3=$(($ptsPC3+$puntosPC3))
 echo "PUNTOS PC3= $ptsPC3 "

 sleep 5
 FIN=1
 break

 fi


 VER_MESA_4 $RONDA

 echo "TURNO DE JUG: "

 JUGAR_JUG #FUCNION PARA QUE JUEGUE EL JUG Y QUE BUSQUE LA FICHA QUE PUEDE INTRODUCIR Y COMPROBANFO QUE LA PUEDE USAR, Y SI PUEDE SACAR Y SACA LA FICHA INCREMENTA
JUGADASJUG


 if [[ $jugadasJUG -eq 7 ]]

 then

 echo "HA GANADO JUG"

 SUMA_PUNTOS_JUG $((7-$jugadasPC1)) $((7-$jugadasPC2)) $((7-$jugadasPC3))
 ptsJUG=$(($ptsJUG+$puntosJUG))
 echo "PUNTOS JUG= $ptsJUG "
 FIN=1
 sleep 5

 fi

 if [[ $CIERRE -ge 4 ]]
 then

 echo "LA PARTIDA ESTA CERRADA"
 #CALCULA A QUIEN LE DA LOS PUNTOS

 puntosCIERREJUG=0
 puntosCIERREPC1=0
 puntosCIERREPC2=0
 puntosCIERREPC3=0

 i=0

 while [[ $i -lt $numFJUG ]]
 do

 DIVIDIR_LADOS {$numFJUG[$i]}

 puntosCIERREJUG=$(($puntosCIERREJUG+$lado1+$lado2))

 done

 i=0

 while [[ $i -lt $numFPC1 ]]
 do

 DIVIDIR_LADOS {$numFPC1[$i]}

 puntosCIERREPC1=$(($puntosCIERREPC1+$lado1+$lado2))

 done

 i=0

 while [[ $i -lt $numFPC2 ]]
 do
 DIVIDIR_LADOS {$numFPC2[$i]}

 puntosCIERREPC2=$(($puntosCIERREPC2+$lado1+$lado2))

 done

 i=0

 while [[ $i -lt $numFPC3 ]]
 do

 DIVIDIR_LADOS {$numFPC3[$i]}
 puntosCIERREPC3=$(($puntosCIERREPC3+$lado1+$lado2))

 done

 if [[ $puntosCIERREJUG -lt $puntosCIERREPC1 ]] && [[ $puntosCIERREJUG -lt $puntosCIERREPC2 ]] && [[ $puntosCIERREJUG -lt $puntosCIERREPC3 ]]
 then

 puntosJUG=$(($puntosCIERREPC1+$puntosCIERREPC2+$puntosCIERREPC3))
 echo "PUNTOS JUG : $puntosJUG "

 elif [[ $puntosCIERREPC1 -lt $puntosCIERREJUG ]] && [[ $puntosCIERREPC1 -lt $puntosCIERREPC2 ]] && [[ $puntosCIERREPC1 -lt $puntosCIERREPC3 ]]

 then
 puntosPC1=$(($puntosCIERREJUG+$puntosCIERREPC2+$puntosCIERREPC3))
 echo "PUNTOS PC1 : $puntosPC1 "



 elif [[ $puntosCIERREPC2 -lt $puntosCIERREJUG ]] && [[ $puntosCIERREPC2 -lt $puntosCIERREPC1 ]] && [[ $puntosCIERREPC2 -lt $puntosCIERREPC1 ]]

 then
 puntosPC2=$(($puntosCIERREJUG+$puntosCIERREPC1+$puntosCIERREPC3))
 echo "PUNTOS PC2 : $puntosPC2 "

 elif [[ $puntosCIERREPC3 -lt $puntosCIERREJUG ]] && [[ $puntosCIERREPC3 -lt $puntosCIERREPC1 ]] && [[ $puntosCIERREPC3 -lt $puntosCIERREPC2 ]]
 then
 puntosPC3=$(($puntosCIERREJUG+$puntosCIERREPC1+$puntosCIERREPC2))
 echo "PUNTOS PC : $puntosPC3 "

 fi
 FIN=1

 break

 fi

 RONDA=$(($RONDA+1))


 done


elif [[ $turno -eq 1 ]] #EMPIEZA PC1
then
 echo "COMIENZA PC1"

 TABLERO[0]=$RESUL_TURNO
 jugadasPC1=1

#CALCULAMOS LA POSICION DE LA PRIMERA FICHA PARA SACARLA DEL VECTOR

j=0
 while test $j -lt 7
 do

 if [[ ${FPC1[$j]} -eq $RESUL_TURNO ]]
 then

 pos=$j

 fi

 j=$(($j+1))

 done


 MOVER_FICHAS_PC1 $pos

 DIVIDIR_LADOS $RESUL_TURNO
 IZQ=$lado1
 DER=$lado2

 RONDA=1

 #CORRESPONDIENTE A LA FICHA DE PC1 RESUL TURNO
 until [[ $FIN -eq 1 ]]
 do


 VER_MESA_4 $RONDA
 echo "TURNO DE PC2"

 JUGAR_PC2 #FUCNION PARA QUE JUEGUE EL BOT 1 Y QUE BUSQUE LA FICHA QUE PUEDE INTRODUCIR Y COMPROBANFO QUE LA PUEDE USAR, Y SI PUEDE SACAR Y SACA LA FICHA
INCREMENTA JUGADASPC1

 if [[ jugadasPC2 -eq 7 ]]
 then
 echo "HA GANADO PC2"

 SUMA_PUNTOS_PC2 $((7-$jugadasPC1)) $((7-$jugadasJUG)) $((7-$jugadasPC3))
 ptsPC2=$(($ptsPC2+$puntosPC2))
 echo "PUNTOS PC2= $ptsPC2 "
 sleep 5
 FIN=1
 break

 fi

 VER_MESA_4 $RONDA

 echo "TURNO DE PC3"

 JUGAR_PC3 #FUCNION PARA QUE JUEGUE EL BOT 1 Y QUE BUSQUE LA FICHA QUE PUEDE INTRODUCIR Y COMPROBANFO QUE LA PUEDE USAR, Y SI PUEDE SACAR Y SACA LA FICHA
INCREMENTA JUGADASPC1

 if [[ jugadasPC3 -eq 7 ]]
 then



 echo "HA GANADO PC3"
 SUMA_PUNTOS_PC3 $((7-$jugadasPC1)) $((7-$jugadasPC2)) $((7-$jugadasJUG))
 ptsPC3=$(($ptsPC3+$puntosPC3))
 echo "PUNTOS PC3= $ptsPC3 "
 sleep 5
 FIN=1
 break
 fi

 VER_MESA_4 $RONDA

 echo "TURNO DE JUG"

 JUGAR_JUG #FUCNION PARA QUE JUEGUE EL BOT 1 Y QUE BUSQUE LA FICHA QUE PUEDE INTRODUCIR Y COMPROBANFO QUE LA PUEDE USAR, Y SI PUEDE SACAR Y SACA LA FICHA
INCREMENTA JUGADASPC1
 if [[ jugadasJUG -eq 7 ]]
 then


 echo "HA GANADO JUG"
 SUMA_PUNTOS_JUG $((7-$jugadasPC1)) $((7-$jugadasPC2)) $((7-$jugadasPC3))
 ptsJUG=$(($ptsJUG+$puntosJUG))
 echo "PUNTOS JUG= $ptsJUG "

 sleep 5
 FIN=1
 break

 fi

 VER_MESA_4 $RONDA

 echo "TURNO DE PC1"

 JUGAR_PC1


 if [[ $jugadasPC1 -eq 7 ]]
 then


 echo "HA GANADO PC1"

 SUMA_PUNTOS_PC1 $((7-$jugadasJUG)) $((7-$jugadasPC2)) $((7-$jugadasPC3))
 ptsPC1=$(($ptsPC1+$puntosPC1))
 echo "PUNTOS PC1= $ptsPC1 "
 FIN=1
 sleep 5

 break

 fi

 if [[ $CIERRE -ge 4 ]]
 then

 echo "LA PARTIDA ESTA CERRADA"

 #CALCULA A QUIEN LE DA LOS PUNTOS

 puntosCIERREJUG=0
 puntosCIERREPC1=0
 puntosCIERREPC2=0
 puntosCIERREPC3=0

 i=0

 while [[ $i -lt $numFJUG ]]
 do

 DIVIDIR_LADOS {$numFJUG[$i]}

 puntosCIERREJUG=$(($puntosCIERREJUG+$lado1+$lado2))

 done

 i=0

 while [[ $i -lt $numFPC1 ]]
 do

 DIVIDIR_LADOS {$numFPC1[$i]}

 puntosCIERREPC1=$(($puntosCIERREPC1+$lado1+$lado2))

 done

 i=0

 while [[ $i -lt $numFPC2 ]]
 do

 DIVIDIR_LADOS {$numFPC2[$i]}
 puntosCIERREPC2=$(($puntosCIERREPC2+$lado1+$lado2))

 done

 i=0

 while [[ $i -lt $numFPC3 ]]
 do

 DIVIDIR_LADOS {$numFPC3[$i]}

 puntosCIERREPC3=$(($puntosCIERREPC3+$lado1+$lado2))

 done
 if [[ $puntosCIERREJUG -lt $puntosCIERREPC1 ]] && [[ $puntosCIERREJUG -lt $puntosCIERREPC2 ]] && [[ $puntosCIERREJUG -lt $puntosCIERREPC3 ]]
 then

 puntosJUG=$(($puntosCIERREPC1+$puntosCIERREPC2+$puntosCIERREPC3))
 echo "PUNTOS JUG : $puntosJUG "

 elif [[ $puntosCIERREPC1 -lt $puntosCIERREJUG ]] && [[ $puntosCIERREPC1 -lt $puntosCIERREPC2 ]] && [[ $puntosCIERREPC1 -lt $puntosCIERREPC3 ]]

 then
 puntosPC1=$(($puntosCIERREJUG+$puntosCIERREPC2+$puntosCIERREPC3))
 echo "PUNTOS PC1 : $puntosPC1 "


 elif [[ $puntosCIERREPC2 -lt $puntosCIERREJUG ]] && [[ $puntosCIERREPC2 -lt $puntosCIERREPC1 ]] && [[ $puntosCIERREPC2 -lt $puntosCIERREPC1 ]]

 then
 puntosPC2=$(($puntosCIERREJUG+$puntosCIERREPC1+$puntosCIERREPC3))
 echo "PUNTOS PC2 : $puntosPC2 "


 elif [[ $puntosCIERREPC3 -lt $puntosCIERREJUG ]] && [[ $puntosCIERREPC3 -lt $puntosCIERREPC1 ]] && [[ $puntosCIERREPC3 -lt $puntosCIERREPC2 ]]

 then
 puntosPC3=$(($puntosCIERREJUG+$puntosCIERREPC1+$puntosCIERREPC2))
 echo "PUNTOS PC : $puntosPC3 "

 fi


 FIN=1
 break
 fi
 RONDA=$(($RONDA+1))


 done
elif [[ $turno -eq 2 ]] #EMPIEZA PC2
then
 echo "COMIENZA PC2"

 TABLERO[0]=$RESUL_TURNO
 jugadasPC2=1
#CALCULAMOS LA POSICION DE LA PRIMERA FICHA PARA SACARLA DEL VECTOR

k=0
 while test $k -lt 7
 do
 if [[ ${FPC2[$k]} -eq $RESUL_TURNO ]]
 then

 pos=$k

 fi
 k=$(($k+1))

 done


 MOVER_FICHAS_PC2 $pos




 DIVIDIR_LADOS $RESUL_TURNO
 IZQ=$lado1
 DER=$lado2

 RONDA=1

 #CORRESPONDIENTE A LA FICHA DE PC2 RESUL TURNO

 until [[ $FIN -eq 1 ]]
 do


 VER_MESA_4 $RONDA

 echo "TURNO DE PC3"

 JUGAR_PC3 #FUCNION PARA QUE JUEGUE EL BOT 1 Y QUE BUSQUE LA FICHA QUE PUEDE INTRODUCIR Y COMPROBANFO QUE LA PUEDE USAR, Y SI PUEDE SACAR Y SACA LA FICHA INCREMENTA
JUGADASPC1
 if [[ jugadasPC3 -eq 7 ]]
 then


 echo "HA GANADO PC3"
 SUMA_PUNTOS_PC3 $((7-$jugadasPC1)) $((7-$jugadasPC2)) $((7-$jugadasJUG))
 ptsPC3=$(($ptsPC3+$puntosPC3))
 echo "PUNTOS PC3= $ptsPC3 "

 sleep 5
 FIN=1
 break
 fi


 VER_MESA_4 $RONDA

 echo "TURNO DE JUG"
 JUGAR_JUG #FUCNION PARA QUE JUEGUE EL BOT 1 Y QUE BUSQUE LA FICHA QUE PUEDE INTRODUCIR Y COMPROBANFO QUE LA PUEDE USAR, Y SI PUEDE SACAR Y SACA LA FICHA
INCREMENTA JUGADASPC1

 if [[ jugadasJUG -eq 7 ]]
 then



 echo "HA GANADO JUG"

 SUMA_PUNTOS_JUG $((7-$jugadasPC1)) $((7-$jugadasPC2)) $((7-$jugadasPC3))
 ptsJUG=$(($ptsJUG+$puntosJUG))
 echo "PUNTOS JUG= $ptsJUG "
 sleep 5
 FIN=1
 break
 fi

 VER_MESA_4 $RONDA

 echo "TRUNO DE PC1"

 JUGAR_PC1 #FUCNION PARA QUE JUEGUE EL BOT 1 Y QUE BUSQUE LA FICHA QUE PUEDE INTRODUCIR Y COMPROBANFO QUE LA PUEDE USAR, Y SI PUEDE SACAR Y SACA LA FICHA
INCREMENTA JUGADASPC1

 if [[ jugadasPC1 -eq 7 ]]
 then

 echo "HA GANADO PC1"

 SUMA_PUNTOS_PC1 $((7-$jugadasJUG)) $((7-$jugadasPC2)) $((7-$jugadasPC3))

 ptsPC1=$(($ptsPC1+$puntosPC1))
 echo "PUNTOS PC1= $ptsPC1 "

 sleep 5
 FIN=1
 break

 fi

 VER_MESA_4 $RONDA

 echo "TURNO DE PC2"

 JUGAR_PC2 #FUCNION PARA QUE JUEGUE EL JUG Y QUE BUSQUE LA FICHA QUE PUEDE INTRODUCIR Y COMPROBANFO QUE LA PUEDE USAR, Y SI PUEDE SACAR Y SACA LA FICHA INCREMENTA
JUGADASJUG


 if [[ $jugadasPC2 -eq 7 ]]
 then


 echo "HA GANADO PC2"

 SUMA_PUNTOS_PC2 $((7-$jugadasPC1)) $((7-$jugadasJUG)) $((7-$jugadasPC3))

 ptsPC2=$(($ptsPC2+$puntosPC2))
 echo "PUNTOS PC2= $ptsPC2 "
 sleep 5
 FIN=1

 break
 fi


 if [[ $CIERRE -ge 4 ]]
 then
 echo "LA PARTIDA ESTA CERRADA"

 #CALCULA A QUIEN LE DA LOS PUNTOS

 puntosCIERREJUG=0
 puntosCIERREPC1=0
 puntosCIERREPC2=0
 puntosCIERREPC3=0

 i=0
 while [[ $i -lt $numFJUG ]]
 do

 DIVIDIR_LADOS {$numFJUG[$i]}

 puntosCIERREJUG=$(($puntosCIERREJUG+$lado1+$lado2))

 done

 i=0

 while [[ $i -lt $numFPC1 ]]
 do
 DIVIDIR_LADOS {$numFPC1[$i]}

 puntosCIERREPC1=$(($puntosCIERREPC1+$lado1+$lado2))

 done

 i=0

 while [[ $i -lt $numFPC2 ]]
 do

 DIVIDIR_LADOS {$numFPC2[$i]}
 puntosCIERREPC2=$(($puntosCIERREPC2+$lado1+$lado2))

 done


 i=0

 while [[ $i -lt $numFPC3 ]]
 do
 DIVIDIR_LADOS {$numFPC3[$i]}

 puntosCIERREPC3=$(($puntosCIERREPC3+$lado1+$lado2))
 done


 if [[ $puntosCIERREJUG -lt $puntosCIERREPC1 ]] && [[ $puntosCIERREJUG -lt $puntosCIERREPC2 ]] && [[ $puntosCIERREJUG -lt $puntosCIERREPC3 ]]
 then

 puntosJUG=$(($puntosCIERREPC1+$puntosCIERREPC2+$puntosCIERREPC3))
 echo "PUNTOS JUG : $puntosJUG "

 elif [[ $puntosCIERREPC1 -lt $puntosCIERREJUG ]] && [[ $puntosCIERREPC1 -lt $puntosCIERREPC2 ]] && [[ $puntosCIERREPC1 -lt $puntosCIERREPC3 ]]

 then
 puntosPC1=$(($puntosCIERREJUG+$puntosCIERREPC2+$puntosCIERREPC3))
 echo "PUNTOS PC1 : $puntosPC1 "



 elif [[ $puntosCIERREPC2 -lt $puntosCIERREJUG ]] && [[ $puntosCIERREPC2 -lt $puntosCIERREPC1 ]] && [[ $puntosCIERREPC2 -lt $puntosCIERREPC1 ]]

 then
 puntosPC2=$(($puntosCIERREJUG+$puntosCIERREPC1+$puntosCIERREPC3))
 echo "PUNTOS PC2 : $puntosPC2 "


 elif [[ $puntosCIERREPC3 -lt $puntosCIERREJUG ]] && [[ $puntosCIERREPC3 -lt $puntosCIERREPC1 ]] && [[ $puntosCIERREPC3 -lt $puntosCIERREPC2 ]]

 then
 puntosPC3=$(($puntosCIERREJUG+$puntosCIERREPC1+$puntosCIERREPC2))
 echo "PUNTOS PC : $puntosPC3 "

 fi


 FIN=1
 break
 fi

 RONDA=$(($RONDA+1))


 done


elif [[ $turno -eq 3 ]] #EMPIEZA PC1
then
 echo "COMIENZA PC3"
 TABLERO[0]=$RESUL_TURNO
 jugadasPC3=1

#CALCULAMOS LA POSICION DE LA PRIMERA FICHA PARA SACARLA DEL VECTOR

l=0
 while test $l -lt 7
 do

 if [[ ${FPC3[$l]} -eq $RESUL_TURNO ]]
 then

 pos=$l

 fi

 l=$(($l+1))

 done

 MOVER_FICHAS_PC3 $pos




 DIVIDIR_LADOS $RESUL_TURNO
 IZQ=$lado1
 DER=$lado2

 RONDA=1

 #CORRESPONDIENTE A LA FICHA DE PC1 RESUL TURNO
 until [[ $FIN -eq 1 ]]
 do


 VER_MESA_4 $RONDA

 echo "TURNO DE JUG"
 JUGAR_JUG #FUCNION PARA QUE JUEGUE EL BOT 1 Y QUE BUSQUE LA FICHA QUE PUEDE INTRODUCIR Y COMPROBANFO QUE LA PUEDE USAR, Y SI PUEDE SACAR Y SACA LA FICHA
INCREMENTA JUGADASPC1
 if [[ jugadasJUG -eq 7 ]]
 then

 echo "HA GANADO JUG"
 SUMA_PUNTOS_JUG $((7-$jugadasPC1)) $((7-$jugadasPC2)) $((7-$jugadasPC3))
 ptsJUG=$(($ptsJUG+$puntosJUG))
 echo "PUNTOS JUG= $ptsJUG "

 sleep 5
 FIN=1
 break

 fi

 VER_MESA_4 $RONDA
 echo "TURNO DE PC1"

 JUGAR_PC1 #FUCNION PARA QUE JUEGUE EL BOT 1 Y QUE BUSQUE LA FICHA QUE PUEDE INTRODUCIR Y COMPROBANFO QUE LA PUEDE USAR, Y SI PUEDE SACAR Y SACA LA FICHA
INCREMENTA JUGADASPC1
 if [[ jugadasPC1 -eq 7 ]]
 then

 echo "HA GANADO PC1"

 SUMA_PUNTOS_PC1 $((7-$jugadasJUG)) $((7-$jugadasPC2)) $((7-$jugadasPC3))
 ptsPC1=$(($ptsPC1+$puntosPC1))
 echo "PUNTOS PC1= $ptsPC1 "
 sleep 5
 FIN=1

 break
 fi
 VER_MESA_4 $RONDA

 echo "TURNO DE PC2"

 JUGAR_PC2 #FUCNION PARA QUE JUEGUE EL BOT 1 Y QUE BUSQUE LA FICHA QUE PUEDE INTRODUCIR Y COMPROBANFO QUE LA PUEDE USAR, Y SI PUEDE SACAR Y SACA LA FICHA
INCREMENTA JUGADASPC1

 if [[ jugadasPC2 -eq 7 ]]
 then


 echo "HA GANADO PC2"
 SUMA_PUNTOS_PC2 $((7-$jugadasPC1)) $((7-$jugadasJUG)) $((7-$jugadasPC3))
 ptsPC2=$(($ptsPC2+$puntosPC2))
 echo "PUNTOS PC2= $ptsPC2 "

 sleep 5
 FIN=1
 break
 fi


 VER_MESA_4 $RONDA

 echo "TURNO DE PC3"
 JUGAR_PC3 #FUCNION PARA QUE JUEGUE EL JUG Y QUE BUSQUE LA FICHA QUE PUEDE INTRODUCIR Y COMPROBANFO QUE LA PUEDE USAR, Y SI PUEDE SACAR Y SACA LA FICHA INCREMENTA
JUGADASJUG


 if [[ $jugadasPC3 -eq 7 ]]
 then

 echo "HA GANADO PC3"

 SUMA_PUNTOS_PC3 $((7-$jugadasPC1)) $((7-$jugadasPC2)) $((7-$jugadasJUG))

 ptsPC3=$(($ptsPC3+$puntosPC3))
 echo "PUNTOS PC3= $ptsPC3 "

 sleep 5
 FIN=1
 break
 fi

 if [[ $CIERRE -ge 4 ]]
 then

 echo "LA PARTIDA ESTA CERRADA"

 #CALCULA A QUIEN LE DA LOS PUNTOS

 puntosCIERREJUG=0
 puntosCIERREPC1=0
 puntosCIERREPC2=0
 puntosCIERREPC3=0

 i=0
 while [[ $i -lt $numFJUG ]]
 do

 DIVIDIR_LADOS {$numFJUG[$i]}

 puntosCIERREJUG=$(($puntosCIERREJUG+$lado1+$lado2))

 done

 i=0

 while [[ $i -lt $numFPC1 ]]
 do

 DIVIDIR_LADOS {$numFPC1[$i]}

 puntosCIERREPC1=$(($puntosCIERREPC1+$lado1+$lado2))

 done
 i=0
 while [[ $i -lt $numFPC2 ]]
 do

 DIVIDIR_LADOS {$numFPC2[$i]}

 puntosCIERREPC2=$(($puntosCIERREPC2+$lado1+$lado2))
 done


 i=0

 while [[ $i -lt $numFPC3 ]]
 do

 DIVIDIR_LADOS {$numFPC3[$i]}

 puntosCIERREPC3=$(($puntosCIERREPC3+$lado1+$lado2))

 done

 if [[ $puntosCIERREJUG -lt $puntosCIERREPC1 ]] && [[ $puntosCIERREJUG -lt $puntosCIERREPC2 ]] && [[ $puntosCIERREJUG -lt $puntosCIERREPC3 ]]
 then

 puntosJUG=$(($puntosCIERREPC1+$puntosCIERREPC2+$puntosCIERREPC3))
 echo "PUNTOS JUG : $puntosJUG "
 elif [[ $puntosCIERREPC1 -lt $puntosCIERREJUG ]] && [[ $puntosCIERREPC1 -lt $puntosCIERREPC2 ]] && [[ $puntosCIERREPC1 -lt $puntosCIERREPC3 ]]

 then
 puntosPC1=$(($puntosCIERREJUG+$puntosCIERREPC2+$puntosCIERREPC3))
 echo "PUNTOS PC1 : $puntosPC1 "



 elif [[ $puntosCIERREPC2 -lt $puntosCIERREJUG ]] && [[ $puntosCIERREPC2 -lt $puntosCIERREPC1 ]] && [[ $puntosCIERREPC2 -lt $puntosCIERREPC1 ]]

 then
 puntosPC2=$(($puntosCIERREJUG+$puntosCIERREPC1+$puntosCIERREPC3))
 echo "PUNTOS PC2 : $puntosPC2 "


 elif [[ $puntosCIERREPC3 -lt $puntosCIERREJUG ]] && [[ $puntosCIERREPC3 -lt $puntosCIERREPC1 ]] && [[ $puntosCIERREPC3 -lt $puntosCIERREPC2 ]]

 then
 puntosPC3=$(($puntosCIERREJUG+$puntosCIERREPC1+$puntosCIERREPC2))
 echo "PUNTOS PC : $puntosPC3 "

 fi


 FIN=1
 break
 fi

 RONDA=$(($RONDA+1))


 done
fi






}

#====================================
#EL JUEGO PARA 2 JUADORESG===========
#====================================
#SI SE PULSA J SE MEZCLAN LAS FICHAS Y SALE POR PANTALLA
function JUEGO_2J
{

TIEMPO_S=$(perl -e 'print time."\n";')

ptsPC1=0
ptsJUG=0
RONDAS=1

while [[ $ptsJUG -lt $PUN ]] && [[ $ptsPC1 -lt $PUN ]]
do

#SE CREAN LAS FICHAS

 ASIG_FICHA

 echo "Se estan mezclando las fichas:"
#SE MEZCLAN LAS FICHAS
 DESORDENAR

#SE REPARTEN LAS FICHAS A LOS 2 JUGADORES Y LOS RESTANTES AL POZO

 REPARTIR_FICHAS

 echo "Se han mezclado las fichas correctamente: COMPROBACION "


 FICHAS_JUG

 echo "================================================"
 FICHAS_PC1

 echo "================================================"

 FICHAS_POZO

 echo "================================================"
 echo "================================================"
 echo "================================================"
 echo "================================================"
 ELEGIR_TURNO_2
#COMIENZO

 numFJUG=7
 numFPC1=7
 numFPC2=7
 numFPC3=7
 jugadasJUG=0
 jugadasPC1=0
 jugadasPC2=0
 jugadasPC3=0
 sacadasPOZO=0
 numFTABLERO=0
 it1=1
 it2=0
 auxiliar=0

 if [[ $turno -eq 0 ]]
 then
 numFJUG=$(($numFJUG-1))

 elif [[ $turno -eq 1 ]]
 then

 numFPC1=$(($numFPC1-1))
 elif [[ $turno -eq 2 ]]
 then

 numFPC2=$(($numFPC2-1))

 elif [[ $turno -eq 3 ]]
 then

 numFPC3=$(($numFPC3-1))

 fi



 PARTIDA_2
 FIN=0
 CIERRE=0
RONDAS=$(($RONDAS+1))

done



if [[ $puntosJUG -gt $PUN ]]
then
jugadorGANADOR="JUG"
fi

if [[ $puntosPC1 -gt $PUN ]]
then
jugadorGANADOR="PC1"
fi

TIEMPO_S=$(($(perl -e 'print time."\n";')-$TIEMPO_S))

declare -a ORDENAR

ORDENAR[1]=$ptsPC1
ORDENAR[2]=$ptsPC2
ORDENAR[3]=$ptsPC3
ORDENAR[4]=$ptsJUG

i=4
 while [[ $i -gt 1 ]]
 do
 if [[ ${ORDENAR[$i]} -lt ${ORDENAR[$(($i-1))]} ]]
 then

 auxi=${ORDENAR[$i]}
 ORDENAR[$i]=${ORDENAR[$(($i-1))]}
 ORDENAR[$(($i-1))]=$auxi
 i=4

 else

 i=$(($i-1))

 fi
 done
printf "$(date +%d)|$(date +%H)|$JUG|$TIEMPO_S|$RONDAS|$INT|$PUN|$jugadorGANADOR|${ORDENAR[4]}-${ORDENAR[3]}-*-*" >> $LOG

 ptsJUG=0
 ptsPC1=0

#printf...
}
#====================================
#EL JUEGO PARA 3 JUGADORES===========
#====================================
function JUEGO_3J
{
TIEMPO_S=$(perl -e 'print time."\n";')
ptsPC1=0
ptsJUG=0
ptsPC2=0
RONDAS=1


RONDAS=1

while [[ $puntosJUG -lt $PUN ]] && [[ $puntosPC1 -lt $PUN ]] && [[ $puntosPC2 -lt $PUN ]]
do

#SE CREAN LAS FICHAS

 ASIG_FICHA

 echo "Se estan mezclando las fichas:"

#SE MEZCLAN LAS FICHAS
 DESORDENAR

#SE REPARTEN LAS FICHAS A LOS 3 JUGADORES Y LOS RESTANTES AL POZO
 REPARTIR_FICHAS
 echo "Se han mezclado las fichas correctamente: COMPROBACION "


 FICHAS_JUG

 echo "================================================"
 FICHAS_PC1
 echo "================================================"

 FICHAS_PC2
 echo "================================================"
 FICHAS_POZO
 echo "================================================"
 ELEGIR_TURNO_3
#COMIENZO
 numFJUG=7
 numFPC1=7
 numFPC2=7
 numFPC3=7
 jugadasJUG=0
 jugadasPC1=0
 jugadasPC2=0
 jugadasPC3=0
 sacadasPOZO=0
 numFTABLERO=0

 if [[ $turno -eq 0 ]]
 then
 numFJUG=$(($numFJUG-1))
 elif [[ $turno -eq 1 ]]
 then

 numFPC1=$(($numFPC1-1))
 elif [[ $turno -eq 2 ]]
 then

 numFPC2=$(($numFPC2-1))

 elif [[ $turno -eq 3 ]]
 then

 numFPC3=$(($numFPC3-1))

 fi


 PARTIDA_3

 FIN=0
 CIERRE=0
RONDAS=$(($RONDAS+1))
done
if [[ $puntosJUG -gt $PUN ]]
then
jugadorGANADOR="JUG"
fi

if [[ $puntosPC1 -gt $PUN ]]
then
jugadorGANADOR="PC1"
fi

if [[ $puntosPC2 -gt $PUN ]]
then
jugadorGANADOR="PC2"
fi


TIEMPO_S=$(($(perl -e 'print time."\n";')-$TIEMPO_S))

declare -a ORDENAR
ORDENAR[1]=$ptsPC1
ORDENAR[2]=$ptsPC2
ORDENAR[3]=$ptsPC3
ORDENAR[4]=$ptsJUG
i=4
 while [[ $i -gt 1 ]]
 do
 if [[ ${ORDENAR[$i]} -lt ${ORDENAR[$(($i-1))]} ]]
 then

 auxi=${ORDENAR[$i]}
 ORDENAR[$i]=${ORDENAR[$(($i-1))]}
 ORDENAR[$(($i-1))]=$auxi
 i=4

 else
 i=$(($i-1))

 fi
 done
printf "$(date +%d)|$(date +%H)|$JUG|$TIEMPO_S|$RONDAS|$INT|$PUN|$jugadorGANADOR|${ORDENAR[4]}-${ORDENAR[3]}-${ORDENAR[2]}-*%n" >> $LOG
 puntosJUG=0
 puntosPC1=0
 puntosPC2=0
}


#===================================================================
#EL JUEGO PARA 4 JUGADORES==========================================
#===================================================================

function JUEGO_4J
{
TIEMPO_S=$(perl -e 'print time."\n";')

ptsPC1=0
ptsJUG=0
ptsPC2=0
ptsPC3=0
RONDAS=1
while [[ $puntosJUG -lt $PUN ]] && [[ $puntosPC1 -lt $PUN ]] && [[ $puntosPC2 -lt $PUN ]] && [[ $puntosPC3 -lt $PUN ]]
do
#SE CREAN LAS FICHAS
 ASIG_FICHA

 echo "Se estan mezclando las fichas:"

#SE MEZCLAN LAS FICHAS

 DESORDENAR

#SE REPARTEN LAS FICHAS A LOS 4 JUGADORES Y EL POZO ESTÁ VAC�

 REPARTIR_FICHAS

 echo "Se han mezclado las fichas correctamente: COMPROBACION "

 FICHAS_JUG

 echo "================================================"
 FICHAS_PC1

 echo "================================================"
 FICHAS_PC2
 echo "==============================================="

 FICHAS_PC3
 echo "==============================================="

 ELEGIR_TURNO_4
#COMIENZO
 numFJUG=7
 numFPC1=7
 numFPC2=7
 numFPC3=7
 jugadasJUG=0
 jugadasPC1=0
 jugadasPC2=0
 jugadasPC3=0
 sacadasPOZO=0
 numFTABLERO=0
 if [[ $turno -eq 0 ]]
 then

 numFJUG=$(($numFJUG-1))
 elif [[ $turno -eq 1 ]]
 then

 numFPC1=$(($numFPC1-1))

 elif [[ $turno -eq 2 ]]
 then
 numFPC2=$(($numFPC2-1))

 elif [[ $turno -eq 3 ]]
 then
 numFPC3=$(($numFPC3-1))
 fi
 PARTIDA_4
 FIN=0
 CIERRE=0

RONDAS=$(($RONDAS+1))

done

if [[ $puntosJUG -gt $PUN ]]
then
jugadorGANADOR="JUG"
fi

if [[ $puntosPC1 -gt $PUN ]]
then
jugadorGANADOR="PC1"
fi

if [[ $puntosPC2 -gt $PUN ]]
then
jugadorGANADOR="PC2"
fi


TIEMPO_S=$(($(perl -e 'print time."\n";')-$TIEMPO_S))
declare -a ORDENAR

ORDENAR[1]=$ptsPC1
ORDENAR[2]=$ptsPC2
ORDENAR[3]=$ptsPC3
ORDENAR[4]=$ptsJUG

i=4
 while [[ $i -gt 1 ]]
 do
 if [[ ${ORDENAR[$i]} -lt ${ORDENAR[$(($i-1))]} ]]
 then
 auxi=${ORDENAR[$i]}
 ORDENAR[$i]=${ORDENAR[$(($i-1))]}
 ORDENAR[$(($i-1))]=$auxi
 i=4
 else
 i=$(($i-1))

 fi
 done

printf "$(date +%d)|$(date +%H)|$JUG|$TIEMPO_S|$RONDAS|$INT|$PUN|$jugadorGANADOR|${ORDENAR[4]}-${ORDENAR[3]}-${ORDENAR[2]}-${ORDENAR[1]}%n" >> $LOG
 puntosJUG=0
 puntosPC1=0
 puntosPC2=0
 puntosPC3=0

}

#====================================
#SELECCION DEL TABLERO===============
#====================================
#SELECCION JUEGO EN FUNCION DE LOS JUGADORES

function JUEGO
{
if test $JUG -eq 2
then
 JUEGO_2J #2 JUGADORES


fi


if test $JUG -eq 3
then

 JUEGO_3J #3 JUGADORES

fi

if test $JUG -eq 4
then

 JUEGO_4J #4 JUGADORES

fi
}

#===============================================================================
#=== EL PROGRAMA PRINCIPAL: SEGUIMIENTO DEL PROGRAMA ====
#===============================================================================

#Muestra el menu y permite elegir una opcion. Tras lo cual redirecciona a la funcion correspondiente
#REALIZAMOS LAS TAREAS PREVIAS ANTES DE COMENZAR EL JUEGO
#DAR VALORES INICIALES
 JUGADORES_TEMP=0
 PUNTOS_TEMP=0
 INTEL_TEMP=0
 LOG_TEMP=0

 #Otro flag llamado error
 ERROR=false
#SI HAY ARGUMENTOS SE LEEN Y SE CORROBORA QUE SON CORRECTOS
 if test $# -ge 1
 then
 DATOS_GRUPO
 fi

#SI NO HA HABIDO ERRORES EN EL PROCESO ANTERIOR SE CARGAN LOS DATOS DE conifg.cfg:

 if test $ERROR = false
 then
 echo "Cargando los datos de la partida:"
 CARGAR_CONFIG
 sleep 1
 fi

#SE INICIALIZAR SALIR CON EL VALOR DE ERROR, YA QUE SI ERROR=true ENTONCES SALIR=true, Y NO SE ENTRARIA A JUGAR

 SALIR=$ERROR

 #SE MUESTRA EL MENU, SE PIDE LA INTRODUCCION DE UN VALOR Y SE ACTUA EN CONSECUENCIA
 until test $SALIR = true
 do
 #ESCRIBIMOS EL MENU
 clear

 TITULO
 echo -e $MENU_TEXT
 echo -n -e "\t\e[1;94m\EL DOMINO\. Introduzca una opción>>"
 read OPCION
 OPCION_TO_UPPER
 case $OPCION in

 "M") #MODIFICAR CONFIG
 CONFIG
 PULSE_PARA_CONTINUAR
;;
 "J") #JUGAR
 JUEGO
 PULSE_PARA_CONTINUAR
;;
 "F") #CLASIFICACIÓN
 CLASIFICACION
PULSE_PARA_CONTINUAR
;;
 "E") #ESTADISITICA
 ESTADISTICA
PULSE_PARA_CONTINUAR
;;
 "S") #SALIR
 SALIR=true
 PULSE_PARA_CONTINUAR
 BORRAR_FICHEROS_TEMPORALES
clear
;;
 *) #DEFAULT
 echo "ERROR: Introduzca un caracter valido"
PULSE_PARA_CONTINUAR
;;
 esac
 done
 
