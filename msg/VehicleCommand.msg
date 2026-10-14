# Vehicle Command uORB message. Used for commanding a mission / action / etc.
# Follows the MAVLink COMMAND_INT / COMMAND_LONG definition.
#
# @description Mensagem uORB central para envio de comandos de ação, modos e navegação.
# Suporta a tradução direta de comandos MAVLink recebidos externamente (Companion/GCS)
# ou gerados internamente pelo executor de missões do PX4.

uint32 MESSAGE_VERSION = 0

uint64 timestamp                   # [us] Tempo desde a inicialização do sistema (Time-sync / Epoch interno)

# --- COMANDOS CUSTOMIZADOS E DE TESTE ---
uint16 VEHICLE_CMD_CUSTOM_0 = 0    # Comando customizado de teste 0
uint16 VEHICLE_CMD_CUSTOM_1 = 1    # Comando customizado de teste 1
uint16 VEHICLE_CMD_CUSTOM_2 = 2    # Comando customizado de teste 2

# --- COMANDOS DE NAVEGAÇÃO E MISSÃO (NAV_*) ---
# param1: Tempo de espera [s] (ignorado por asa fixa, tempo pairando para multirotores)
# param2: Raio de aceitação [m] (se atingido dentro da esfera, o waypoint é considerado alcançado)
# param3: Raio de passagem [m] (0 para passar direto. >0 órbita horária, <0 órbita anti-horária)
# param4: Ângulo de Yaw desejado no waypoint (multirotores)
# param5 (double): Latitude do destino (WGS-84)
# param6 (double): Longitude do destino (WGS-84)
# param7: Altitude do destino (AMSL)
uint16 VEHICLE_CMD_NAV_WAYPOINT = 16

# param3: Raio ao redor do ponto [m] (>0 horário, <0 anti-horário)
# param4: Ângulo de Yaw desejado
# param5/6/7: Coordenadas globais de Loiter (Lat/Lon/Alt)
uint16 VEHICLE_CMD_NAV_LOITER_UNLIM = 17 # Mantém Loiter no ponto por tempo ilimitado
uint16 VEHICLE_CMD_NAV_LOITER_TURNS = 18 # Mantém Loiter no ponto por X voltas (param1 = Voltas)
uint16 VEHICLE_CMD_NAV_LOITER_TIME  = 19 # Mantém Loiter no ponto por X segundos (param1 = Segundos)

uint16 VEHICLE_CMD_NAV_RETURN_TO_LAUNCH = 20 # Executa a rotina de Retorno ao Ponto de Decolagem (RTL)

# param4: Ângulo de Yaw desejado no pouso
# param5/6/7: Coordenadas globais do pouso (Lat/Lon/Alt)
uint16 VEHICLE_CMD_NAV_LAND = 21

# param1: Pitch mínimo de decolagem (apenas asa fixa)
# param4: Ângulo de Yaw em graus [0,360] no referencial NED
# param5/6/7: Coordenadas globais de decolagem (Lat/Lon/Alt)
uint16 VEHICLE_CMD_NAV_TAKEOFF = 22

uint16 VEHICLE_CMD_NAV_PRECLAND = 23 # Inicia pouso de precisão baseado em sensores (IR, tags, visão)

# param1: Raio da órbita [m]
# param2: Velocidade tangencial [m/s]
# param3: Comportamento do Yaw durante a órbita (ver sub-enum ORBIT_YAW_BEHAVIOUR)
# param5/6/7: Coordenadas do centro da órbita (X/Y/Z ou Lat/Lon/Alt)
uint16 VEHICLE_CMD_DO_ORBIT = 34

# param1: Raio Maior [m]
# param2: Raio Menor [m]
# param3: Velocidade de avanço [m/s]
# param4: Orientação angular do padrão
# param5/6/7: Coordenadas do centro do padrão (Lat/Lon/Alt)
uint16 VEHICLE_CMD_DO_FIGUREEIGHT = 35

# param1: Modo de Região de Interesse (ver sub-enum VEHICLE_ROI)
# param2: Índice da missão ou ID do alvo rastreado
# param3: Índice do ROI (permite gerenciar múltiplos alvos)
# param5/6/7: Coordenadas de foco do ROI fixo (X/Y/Z)
uint16 VEHICLE_CMD_NAV_ROI = 80

# param1: Obstacle Avoidance Local (0:Desativa, 1:Ativa, 2:Ativa e reseta mapa)
# param2: Path Planning Global (0:Desativa, 1:Ativa, 2:Ativa e reseta grid, 3:Ativa e reseta rota)
# param4: Ângulo de Yaw final desejado no objetivo [0,360]
# param5/6/7: Coordenadas globais do objetivo final (Lat/Lon/Alt)
uint16 VEHICLE_CMD_NAV_PATHPLANNING = 81

# Comandos específicos para aeronaves VTOL (Transição de asa fixa / multirotor)
uint16 VEHICLE_CMD_NAV_VTOL_TAKEOFF = 84 # Decolagem vertical seguida de transição para asa fixa
uint16 VEHICLE_CMD_NAV_VTOL_LAND    = 85 # Transição para multirotor seguida de pouso vertical

# param1: Timeout de controle externo [s] (0 = sem timeout)
# param2: Altitude mínima absoluta AMSL [m] (se violada, aborta e retoma missão)
# param3: Altitude máxima absoluta AMSL [m] (se violada, aborta e retoma missão)
# param4: Raio de movimento horizontal máximo [m] medido a partir da execução do comando
uint16 VEHICLE_CMD_NAV_GUIDED_LIMITS = 90 # Define limites geográficos de segurança para controle externo (Offboard)

# param1: System ID do controlador mestre
# param2: Component ID do controlador mestre
uint16 VEHICLE_CMD_NAV_GUIDED_MASTER = 91

# param1: Delay de execução [s] (-1 para habilitar os campos de horário UTC nos params seguintes)
# param2: Hora UTC [0-23] (-1 para ignorar)
# param3: Minuto UTC [0-59] (-1 para ignorar)
# param4: Segundo UTC [0-59]
uint16 VEHICLE_CMD_NAV_DELAY = 93

uint16 VEHICLE_CMD_NAV_LAST = 95 # NOP - Marcador de limite superior para comandos do tipo NAV

# --- COMANDOS CONDICIONAIS DE MISSÃO (CONDITION_*) ---
uint16 VEHICLE_CMD_CONDITION_DELAY      = 112 # Pausa a máquina de estados da missão por X segundos (param1)
uint16 VEHICLE_CMD_CONDITION_CHANGE_ALT = 113 # Altera altitude na taxa de param1 [m/s]. Segura missão até atingir param7 (Alt final)
uint16 VEHICLE_CMD_CONDITION_DISTANCE   = 114 # Segura missão até que a distância ao próximo WP seja menor que param1 [m]

# param1: Ângulo alvo [0,360] (0 = Norte)
# param2: Velocidade angular do giro [deg/s]
# param3: Direção (-1: Anti-horário, 1: Horário)
# param4: Tipo de referência (0: Absoluto, 1: Relativo ao rumo atual)
uint16 VEHICLE_CMD_CONDITION_YAW = 115

uint16 VEHICLE_CMD_CONDITION_LAST = 159 # NOP - Marcador de limite superior para comandos condicionais

# param1: Modo 2D (0: Ortogonal à rota planejada)
# param2: Modo de altitude (0: Ignora altitude do gate)
# param5/6/7: Posição do Gate (Lat/Lon/Alt)
uint16 VEHICLE_CMD_CONDITION_GATE = 4501 # Aguarda até cruzar um plano limite (Gate)

# --- COMANDOS DE AÇÃO IMEDIATA (DO_*) ---
uint16 VEHICLE_CMD_DO_SET_MODE = 176 # Altera o modo do sistema de acordo com o enum MAV_MODE (param1)

# param1: Número de sequência (ID) do item da missão alvo
# param2: Contagem de repetições do ciclo
uint16 VEHICLE_CMD_DO_JUMP = 177

# param1: Tipo de velocidade (0: Airspeed, 1: Groundspeed, 2: Climb, 3: Descend)
# param2: Velocidade alvo [m/s] (-1 para manter inalterado)
# param3: Aceleração/Throttle em porcentagem [%] (-1 para manter inalterado)
uint16 VEHICLE_CMD_DO_CHANGE_SPEED = 178

# param1: Escolha da referência (1: Usa posição atual do GPS, 0: Usa coordenadas dos params 5/6/7)
uint16 VEHICLE_CMD_DO_SET_HOME = 179

# param1: ID numérico mapeado do parâmetro interno do firmware
# param2: Valor a ser injetado no parâmetro
uint16 VEHICLE_CMD_DO_SET_PARAMETER = 180

# param1: Número identificador do relé físico (GPIO Out)
# param2: Estado (1: Ligado, 0: Desligado)
uint16 VEHICLE_CMD_DO_SET_RELAY = 181

# param1: ID do relé | param2: Ciclos de repetição | param3: Período do ciclo [s]
uint16 VEHICLE_CMD_DO_REPEAT_RELAY = 182

# param1: Canal do Servo | param2: Pulso PWM [us] (Ex: 1000 a 2000) | param3: Ciclos | param4: Tempo [s]
uint16 VEHICLE_CMD_DO_REPEAT_SERVO = 184

uint16 VEHICLE_CMD_DO_FLIGHTTERMINATION = 185 # Ativa terminação forçada de voo imediatamente (Corte de motores/Paraquedas) se param1 > 0.5

# param1: Altitude alvo | param2: Frame de referência da altitude
uint16 VEHICLE_CMD_DO_CHANGE_ALTITUDE = 186

# param1 a param6: Valores de controle direto para as saídas de atuadores 1 a 6 | param7: Índice do grupo
uint16 VEHICLE_CMD_DO_SET_ACTUATOR = 187

# param5/6: Coordenadas aproximadas para busca do circuito de pouso mais próximo na missão
uint16 VEHICLE_CMD_DO_LAND_START = 189

uint16 VEHICLE_CMD_DO_GO_AROUND = 191 # Comando de arremetida (Go-Around) para abortar pouso autônomo com segurança. param1 = Altitude de escape

# param1: Velocidade de aproximação [m/s] | param2: Bitmask de eixos | param3: Raio loiter (asa fixa) | param4: Yaw desejado
# param5/6/7: Coordenadas espaciais do novo alvo de posicionamento (Lat/Lon/Alt)
uint16 VEHICLE_CMD_DO_REPOSITION = 192

uint16 VEHICLE_CMD_DO_PAUSE_CONTINUE = 193 # Alterna estados de pausa e retomada de missões ou trajetórias automáticas

# Comandos de apontamento estático do sensor/câmera (ROI)
uint16 VEHICLE_CMD_DO_SET_ROI_LOCATION     = 195 # Aponta câmera para localização fixa (param5/6/7)
uint16 VEHICLE_CMD_DO_SET_ROI_WPNEXT_OFFSET = 196 # Aponta câmera para o próximo WP aplicando offsets em param5(Pitch), param6(Roll) e param7(Yaw)
uint16 VEHICLE_CMD_DO_SET_ROI_NONE          = 197 # Cancela rastreamento de ROI atual e retorna sensores para a orientação padrão

# param1: ID da Câmera (-1 = todas) | param2: Transmissão (0: off, 1: compresso, 2: raw) | param3: Modo (0: streaming, >0: captura a cada N s) | param4: Gravação
uint16 VEHICLE_CMD_DO_CONTROL_VIDEO = 200

uint16 VEHICLE_CMD_DO_SET_ROI       = 201 # Controle genérico de ROI (idêntico ao VEHICLE_CMD_NAV_ROI, mas de execução imediata)
uint16 VEHICLE_CMD_DO_DIGICAM_CONTROL = 203 # Gatilho direto de controle legado para câmeras digitais

# param1: Modo de operação do Mount (ver sub-enum MAV_MOUNT_MODE)
# param2: Ativa estabilização de Roll (1: sim, 0: não) | param3: Estabilização de Pitch | param4: Estabilização de Yaw
uint16 VEHICLE_CMD_DO_MOUNT_CONFIGURE = 204

# param1: Pitch/Lat | param2: Roll/Lon | param3: Yaw/Alt (depende do modo de operação definido no param7)
uint16 VEHICLE_CMD_DO_MOUNT_CONTROL = 205

uint16 VEHICLE_CMD_DO_SET_CAM_TRIGG_DIST = 206 # Configura disparo de câmera por distância métrica espacial percorrida (param1 = Distância [m])
uint16 VEHICLE_CMD_DO_FENCE_ENABLE      = 207 # Ativa ou desativa cercas geográficas virtuais / Geofence (param1: 1=Ativa, 0=Desativa)
uint16 VEHICLE_CMD_DO_PARACHUTE          = 208 # Controle manual de ejeção do paraquedas (param1: ver sub-enum PARACHUTE_ACTION)

# param1: ID/Instância do motor | param2: Tipo de comando de aceleração | param3: Valor do throttle | param4: Timeout [s]
uint16 VEHICLE_CMD_DO_MOTOR_TEST   = 209
uint16 VEHICLE_CMD_DO_INVERTED_FLIGHT = 210 # Força voo invertido em aeronaves homologadas (param1: 1=Invertido, 0=Normal)
uint16 VEHICLE_CMD_DO_GRIPPER         = 211 # Acionamento de garras de carga/servos de liberação (ver sub-enum GRIPPER_ACTION)
uint16 VEHICLE_CMD_DO_SET_CAM_TRIGG_INTERVAL = 214 # Configura disparo de câmera baseado em intervalos fixos de tempo (param1 = Intervalo [ms])

# Controle de gimbals tridimensionais usando quatérnios de atitude espacial diretos (param1=qw, param2=qx, param3=qy, param4=qz)
uint16 VEHICLE_CMD_DO_MOUNT_CONTROL_QUAT = 220

uint16 VEHICLE_CMD_DO_GUIDED_MASTER = 221 # Duplicata operacional imediata do comando NAV_GUIDED_MASTER
uint16 VEHICLE_CMD_DO_GUIDED_LIMITS = 222 # Duplicata operacional imediata do comando NAV_GUIDED_LIMITS
uint16 VEHICLE_CMD_DO_LAST          = 240 # NOP - Marcador de limite superior para blocos operacionais de ação imediata

# --- PROCESSOS DE PRÉ-VOO E MANUTENÇÃO (PREFLIGHT_*) ---
uint16 VEHICLE_CMD_PREFLIGHT_CALIBRATION            = 241 # Executa calibração geral de sensores (Aceito apenas em solo/disarmed)
uint16 PREFLIGHT_CALIBRATION_TEMPERATURE_CALIBRATION = 3   # Sub-parâmetro injetado em param1 para iniciar calibração térmica de sensores

# param1: Sensor alvo (0:giros, 1:acelerômetros, 2:magnetômetro, 3:barômetro, 4:optical flow)
# param2/3/4: Offsets brutos para os eixos X, Y e Z nas unidades nativas do sensor alvo
uint16 VEHICLE_CMD_PREFLIGHT_SET_SENSOR_OFFSETS = 242

uint16 VEHICLE_CMD_PREFLIGHT_UAVCAN             = 243 # Dispara mapeamento dinâmico de nós atuadores via barramento CAN/UAVCAN (param1=1 inicia)

# param1: Controle de parâmetros (0: Lê da Flash/EEPROM, 1: Grava parâmetros atuais na Flash)
# param2: Controle de missões (0: Lê da Flash/EEPROM, 1: Grava missão atual na Flash)
uint16 VEHICLE_CMD_PREFLIGHT_STORAGE            = 245

# param1: Piloto Automático (0: NOP, 1: Reboot PX4, 2: Shutdown PX4)
# param2: Companion Computer / OBC (0: NOP, 1: Reboot Raspberry/Odroid, 2: Shutdown OBC)
uint16 VEHICLE_CMD_PREFLIGHT_REBOOT_SHUTDOWN    = 246

# Controle de levantamentos aerofotogramétricos oblíquos (Mapeamento 3D complexo de fachadas)
uint16 VEHICLE_CMD_OBLIQUE_SURVEY           = 260
uint16 VEHICLE_CMD_DO_SET_STANDARD_MODE     = 262 # Força o acionamento de modos padrão MAVLink estruturados
uint16 VEHICLE_CMD_GIMBAL_DEVICE_INFORMATION = 283 # Requisita metadados estruturados de recursos e versão de hardware do gimbal conectado

# --- FLUXO PRINCIPAL E GERENCIAMENTO DE HARDWARE ---
# param1: ID do item inicial da missão onde o sequenciador deve começar
# param2: ID do item final onde a missão será dada por encerrada automaticamente
uint16 VEHICLE_CMD_MISSION_START = 300

uint16 VEHICLE_CMD_ACTUATOR_TEST   = 310 # Executa movimentação de teste de atuadores individuais (param1=Valor [-1,1], param2=Timeout [s])
uint16 VEHICLE_CMD_CONFIGURE_ACTUATOR = 311 # Envia diretivas em tempo real de reconfiguração de funções das saídas físicas

# param1: Estado de armamento desejado (1: Armar motores, 0: Desarmar sistema de propulsão)
uint16 VEHICLE_CMD_COMPONENT_ARM_DISARM = 400

uint16 VEHICLE_CMD_RUN_PREARM_CHECKS = 401 # Força a re-execução imediata dos testes internos de segurança pré-armamento (Pre-flight safety checks)
uint16 VEHICLE_CMD_INJECT_FAILURE     = 420 # Injeta falhas de hardware via software para testes de redundância (SITL/HITL)

# Inicializa pareamento de receptores de rádio RC (param1: 0=Spektrum | param2: 0=DSM2, 1=DSMX)
uint16 VEHICLE_CMD_START_RX_PAIR = 500

uint16 VEHICLE_CMD_REQUEST_MESSAGE             = 512 # Solicita envio pontual de uma instância de mensagem uORB/MAVLink específica
uint16 VEHICLE_CMD_REQUEST_CAMERA_INFORMATION = 521 # Requisita dados estruturados estáticos de capacidades da câmera (CAMERA_INFORMATION)
uint16 VEHICLE_CMD_SET_CAMERA_MODE             = 530 # Alterna modos internos de captura da câmera (Ex: Modo foto vs Modo gravação de vídeo)
uint16 VEHICLE_CMD_SET_CAMERA_ZOOM             = 531 # Controla nível de zoom ótico/digital da câmera embarcada
uint16 VEHICLE_CMD_SET_CAMERA_FOCUS            = 532 # Ajusta foco (manual/automático) das lentes do payload óptico

# Controle avançado e arbitragem de gimbals de câmera via arquitetura Gimbal Manager do MAVLink v2
uint16 VEHICLE_CMD_DO_GIMBAL_MANAGER_PITCHYAW   = 1000 # Envia setpoints diretos de malha fechada de Pitch e Yaw ao gerenciador do Gimbal
uint16 VEHICLE_CMD_DO_GIMBAL_MANAGER_CONFIGURE  = 1001 # Define hierarquia e prioridades de controle (SysID/CompID primário vs secundário)

uint16 VEHICLE_CMD_IMAGE_START_CAPTURE = 2000 # Inicia disparo sequencial de captura de fotos
uint16 VEHICLE_CMD_DO_TRIGGER_CONTROL  = 2003 # Habilita ou desabilita o subsistema físico automatizado de trigger de câmera do PX4
uint16 VEHICLE_CMD_VIDEO_START_CAPTURE = 2500 # Inicia gravação contínua de fluxo de vídeo digital
uint16 VEHICLE_CMD_VIDEO_STOP_CAPTURE  = 2501 # Interrompe gravação de fluxo de vídeo e fecha o arquivo gerado
uint16 VEHICLE_CMD_LOGGING_START       = 2510 # Inicia a transmissão em tempo real de logs estruturados em formato ULog via link de telemetria
uint16 VEHICLE_CMD_LOGGING_STOP        = 2511 # Interrompe a transmissão de streaming de ULog ativo
uint16 VEHICLE_CMD_CONTROL_HIGH_LATENCY = 2600 # Gerencia o tráfego e ativação de links de dados de alta latência (Ex: Telemetria via Satélite/Iridium)
uint16 VEHICLE_CMD_DO_VTOL_TRANSITION   = 3000 # Força a transição manual imediata de estado de voo em VTOL (Multirotor <-> Asa Fixa)
uint16 VEHICLE_CMD_ARM_AUTHORIZATION_REQUEST = 3001 # Requisição de validação externa em sistemas com chaves de armamento centralizadas de segurança
uint16 VEHICLE_CMD_PAYLOAD_PREPARE_DEPLOY    = 30001 # Prepara a máquina de estados do payload para ejeção/operação dentro do plano de voo
uint16 VEHICLE_CMD_PAYLOAD_CONTROL_DEPLOY    = 30002 # Executa e controla dinamicamente o disparo ou deploy do mecanismo do payload

# param5/6: Posição do sensor (se zero, assume posição GPS atual) | param7: Proa/Yaw de referência conhecida
uint16 VEHICLE_CMD_FIXED_MAG_CAL_YAW = 42006 # Calibração ultra-rápida de magnetômetro baseada em tabelas magnéticas globais (WMM) e proa conhecida
uint16 VEHICLE_CMD_DO_WINCH          = 42600 # Comanda a operação mecânica de guinchos/cabos de resgate e entrega de carga

# Comandos de correção externa para algoritmos de estimação de estado (EKF2) em cenários de navegação estimada (Dead Reckoning)
uint16 VEHICLE_CMD_EXTERNAL_POSITION_ESTIMATE = 43003 # Reseta/Injeta posição global externa estimada no filtro de Kalman
uint16 VEHICLE_CMD_EXTERNAL_WIND_ESTIMATE     = 43004 # Injeta vetor de estimativa de vento externo para ajuste de controle aerodinâmico

# --- EXTENSÕES INTERNAS EXCLUSIVAS DO ECOSSISTEMA PX4 ---
uint32 VEHICLE_CMD_PX4_INTERNAL_START = 65537 # Marcador inicial para comandos exclusivos que operam acima do limite de 16-bits do MAVLink

# param5/6/7: Coordenadas de origem física local (Lat/Lon/Alt AMSL vinda do receptor GNSS)
uint32 VEHICLE_CMD_SET_GPS_GLOBAL_ORIGIN = 100000 # Define a origem geográfica global absoluta que representará o ponto (0,0,0) local do EKF2

# param1: Estado de navegação alvo mapeado diretamente conforme a máquina de estados interna do Commander do PX4
uint32 VEHICLE_CMD_SET_NAV_STATE = 100001

# --- SUB-ENUMERATIONS E MÁSCARAS DE DADOS PARA PARÂMETROS ESPECÍFICOS ---

# Modos de operação de Gimbal/Mount (Injetados via param1 ou param7 em comandos de Mount)
uint8 VEHICLE_MOUNT_MODE_RETRACT           = 0 # Recolhe o gimbal para a posição de proteção, desativa estabilização e desliga motores
uint8 VEHICLE_MOUNT_MODE_NEUTRAL           = 1 # Move o gimbal para o centro neutro estático alinhado com a estrutura física da aeronave
uint8 VEHICLE_MOUNT_MODE_MAVLINK_TARGETING = 2 # Transfere o controle dos eixos para setpoints dinâmicos via MAVLink com estabilização ativa
uint8 VEHICLE_MOUNT_MODE_RC_TARGETING      = 3 # Vincula o controle de apontamento diretamente aos canais mapeados no rádio controle (RC)
uint8 VEHICLE_MOUNT_MODE_GPS_POINT         = 4 # Trava o foco da câmera apontado fixamente para uma coordenada global (Lat/Lon/Alt)
uint8 VEHICLE_MOUNT_MODE_ENUM_END          = 5

# Modos de operação de Região de Interesse / ROI (Injetados via param1)
uint8 VEHICLE_ROI_NONE     = 0 # Cancela foco em alvos, sensores retornam para comportamento padrão de voo
uint8 VEHICLE_ROI_WPNEXT   = 1 # Mantém os sensores apontados continuamente na direção do próximo waypoint da rota
uint8 VEHICLE_ROI_WPINDEX  = 2 # Trava o apontamento dos sensores para um waypoint específico da lista pelo seu ID
uint8 VEHICLE_ROI_LOCATION = 3 # Fixa o apontamento dos sensores para uma coordenada geográfica estática no espaço
uint8 VEHICLE_ROI_TARGET   = 4 # Habilita rastreamento contínuo de um alvo dinâmico móvel rastreado pelo sistema
uint8 VEHICLE_ROI_ENUM_END = 5

# Ações de atuação do subsistema de paraquedas de emergência
uint8 PARACHUTE_ACTION_DISABLE = 0
uint8 PARACHUTE_ACTION_ENABLE  = 1
uint8 PARACHUTE_ACTION_RELEASE = 2 # Ejeta fisicamente o paraquedas cortando os motores no processo

# Mapeamento de unidades de hardware para o comando de injeção de falhas simuladas (VEHICLE_CMD_INJECT_FAILURE)
uint8 FAILURE_UNIT_SENSOR_GYRO           = 0
uint8 FAILURE_UNIT_SENSOR_ACCEL          = 1
uint8 FAILURE_UNIT_SENSOR_MAG            = 2
uint8 FAILURE_UNIT_SENSOR_BARO           = 3
uint8 FAILURE_UNIT_SENSOR_GPS            = 4
uint8 FAILURE_UNIT_SENSOR_OPTICAL_FLOW   = 5
uint8 FAILURE_UNIT_SENSOR_VIO            = 6
uint8 FAILURE_UNIT_SENSOR_DISTANCE_SENSOR = 7
uint8 FAILURE_UNIT_SENSOR_AIRSPEED       = 8
uint8 FAILURE_UNIT_SYSTEM_BATTERY        = 100
uint8 FAILURE_UNIT_SYSTEM_MOTOR          = 101
uint8 FAILURE_UNIT_SYSTEM_SERVO          = 102
uint8 FAILURE_UNIT_SYSTEM_AVOIDANCE      = 103
uint8 FAILURE_UNIT_SYSTEM_RC_SIGNAL      = 104
uint8 FAILURE_UNIT_SYSTEM_MAVLINK_SIGNAL = 105

# Tipos de assinatura de falha a serem injetadas no comportamento do componente alvo selecionado
uint8 FAILURE_TYPE_OK           = 0 # Retorna o componente ao comportamento operacional normal
uint8 FAILURE_TYPE_OFF          = 1 # Simula desligamento completo ou perda total de comunicação com o dispositivo
uint8 FAILURE_TYPE_STUCK        = 2 # Trava a leitura do sensor no último valor válido lido antes da falha
uint8 FAILURE_TYPE_GARBAGE      = 3 # Injeta ruído aleatório de alta frequência inviabilizando o uso dos dados pelo EKF2
uint8 FAILURE_TYPE_WRONG        = 4 # Aplica um offset estático constante corrompendo a calibração do sensor
uint8 FAILURE_TYPE_SLOW         = 5 # Reduz a taxa de atualização drástica do componente simulando sobrecarga de barramento
uint8 FAILURE_TYPE_DELAYED      = 6 # Introduz um atraso temporal fixo na chegada das leituras ao estimador
uint8 FAILURE_TYPE_INTERMITTENT = 7 # Alterna o funcionamento aleatoriamente entre operacional e em falha

# Tipos de referência de velocidade para o comando VEHICLE_CMD_DO_CHANGE_SPEED (Injetado via param1)
uint8 SPEED_TYPE_AIRSPEED     = 0 # Velocidade relativa ao ar (Crucial para sustentação aerodinâmica de asas fixas)
uint8 SPEED_TYPE_GROUNDSPEED  = 1 # Velocidade real em relação ao solo obtida via GPS/Filtro
uint8 SPEED_TYPE_CLIMB_SPEED  = 2 # Velocidade vertical positiva de subida
uint8 SPEED_TYPE_DESCEND_SPEED = 3 # Velocidade vertical negativa de descida

# Comportamento de orientação do Yaw durante a execução do comando de órbita (Injetado via param3)
uint8 ORBIT_YAW_BEHAVIOUR_HOLD_FRONT_TO_CIRCLE_CENTER = 0 # Mantém o nariz do drone apontado fixamente para o centro da órbita
uint8 ORBIT_YAW_BEHAVIOUR_HOLD_INITIAL_HEADING        = 1 # Trava a proa no ângulo que estava no momento do início do comando
uint8 ORBIT_YAW_BEHAVIOUR_UNCONTROLLED                = 2 # Desativa o controle de guinada automático deixando o Yaw livre
uint8 ORBIT_YAW_BEHAVIOUR_HOLD_FRONT_TANGENT_TO_CIRCLE = 3 # Alinha o nariz do drone tangencialmente apontando para a direção do movimento
uint8 ORBIT_YAW_BEHAVIOUR_RC_CONTROLLED               = 4 # Permite que o piloto altere o Yaw manualmente via rádio sem quebrar a trajetória
uint8 ORBIT_YAW_BEHAVIOUR_UNCHANGED                  = 5 # Mantém o comportamento de orientação de Yaw configurado anteriormente no sistema

# Ações básicas de armamento (Injetado via param1 em VEHICLE_CMD_COMPONENT_ARM_DISARM)
int8 ARMING_ACTION_DISARM = 0
int8 ARMING_ACTION_ARM    = 1

# Ações de controle de garras físicas de carga (Injetado via param2 em VEHICLE_CMD_DO_GRIPPER)
uint8 GRIPPER_ACTION_RELEASE = 0 # Abre o mecanismo liberando o objeto preso
uint8 GRIPPER_ACTION_GRAB    = 1 # Fecha o mecanismo prendendo a carga útil

uint8 ORB_QUEUE_LENGTH = 8 # Define o tamanho máximo de retenção de mensagens não processadas na fila uORB

# --- DECLARAÇÃO DE VARIÁVEIS DO PAYLOAD REAIS DA MENSAGEM ---
float32 param1           # Parâmetro genérico 1 (Geralmente dados de controle, configurações e flags de sub-enums)
float32 param2           # Parâmetro genérico 2 (Geralmente tempos de integração, ganhos secundários ou velocidades)
float32 param3           # Parâmetro genérico 3 (Geralmente raios de órbita, limites dinâmicos ou direções de giro)
float32 param4           # Parâmetro genérico 4 (Geralmente ângulos de orientação, atitudes de Yaw e máscaras de bits)
float64 param5           # Parâmetro genérico 5 - Alta Precisão (Usado para transporte de coordenadas de Latitude global)
float64 param6           # Parâmetro genérico 6 - Alta Precisão (Usado para transporte de coordenadas de Longitude global)
float32 param7           # Parâmetro genérico 7 (Usado para transporte de altitudes ou parâmetros flutuantes finais)
uint32 command           # Identificador Numérico de Comando Executável (Corresponde aos IDs VEHICLE_CMD_*)
uint8 target_system      # Identificação do MAVLink System ID destino do comando
uint8 target_component   # Identificação do MAVLink Component ID destino (0 envia em broadcast para todas as placas/periféricos)
uint8 source_system      # Identificação do MAVLink System ID de quem gerou a mensagem (Ex: ID da Raspberry Pi)
uint16 source_component  # Identificação do MAVLink Component ID / Executor de modo de quem originou o envio
uint8 confirmation       # Contador de pacotes de confirmação (0 para envio inicial, incrementos sequenciais para reenvios críticos)
bool from_external       # Flag de auditoria de segurança (Define se a origem é um link externo MAVLink ou nativa interna)

uint16 COMPONENT_MODE_EXECUTOR_START = 1000 # Endereçamento inicial padrão para executores customizados de modos de voo

# TOPICS vehicle_command gimbal_v1_command vehicle_command_mode_executor