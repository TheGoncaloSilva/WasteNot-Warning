<template>
  <div class="row row-equal">
    <div class="flex xs12 sm6 md6 xl3 lg3">
      <va-card class="d-flex">
        <va-card-content>
            <div class="system-arm-section">
              <button :class="['outer-button', {'armed': isArmed && !alarmTriggered, 'disarmed': !isArmed && !alarmTriggered , 'triggered': alarmTriggered}]">
                <button :class="['inner-button', {'armed': isArmed && !alarmTriggered, 'disarmed': !isArmed && !alarmTriggered , 'triggered': alarmTriggered}]" @click="toggleArmedStatus">
                  {{ getSystemStatus() }}
                </button>
                <span :class="{'armed': isArmed && !alarmTriggered, 'disarmed': !isArmed && !alarmTriggered , 'triggered': alarmTriggered}">
                  {{ getSystemStatus() }}
                </span>
              </button>
            </div>
          
        </va-card-content>
      </va-card>
    </div>

    <div class="flex xs12 sm6 md6 xl3 lg3">
      <va-card stripe stripe-color="info">
        <va-card-title>
          Estado do Sistema
        </va-card-title>
        <va-card-content>
          <p class="rich-theme-card-text">
            {{ getSystemDescription() }}
          </p>

          <div class="mt-3">
            <va-button color="primary" @click="triggerAlarm" v-if="isArmed && !alarmTriggered">
              Soar Alarme
            </va-button>
            <va-button color="primary" disabled v-else>
              Soar Sistema
            </va-button>
          </div>
        </va-card-content>
      </va-card>
    </div>
    
    <div class="flex xl6 xs12 lg6">
      <div class="row">
        <div v-for="(info, idx) in infoTiles" :key="idx" class="flex xs12 sm4">
          <va-card class="mb-4" :color="info.color">
            <va-card-content>
              <h2 class="va-h2 ma-0" style="color: white">{{ info.value }}</h2>
              <p style="color: white">{{ info.text }}</p>
            </va-card-content>
          </va-card>
        </div>
      </div>

      <div class="row">

          <div class="flex xs12 sm6 md6" v-for="MAN in nextMaintenanceList">
            <va-card>
              <va-card-title>
                Próxima Manutenção
              </va-card-title>
              <va-card-content>
                <div class="row row-separated">
                  <div class="flex xs9">
                    <h2 class="va-h2 ma-0" :style="{ color: colors.primary }">{{ MAN.Man_inicio }}</h2>
                    <p class="no-wrap">{{ MAN.AR_localizacao }}</p>
                  </div>  
                  <div class="flex xs3">
                      <h2 class="va-h2 ma-0 va-text-center" :style="{ color: colors.warning }">{{ MAN.Man_duracao }}</h2>
                      <p class="va-text-center">Horas</p>
                    </div>
                </div>
              </va-card-content>
            </va-card>
          </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
  import { ref } from 'vue'
  import { useI18n } from 'vue-i18n'
  import { VaCard, VaCardContent, VaCardTitle, VaButton, useColors } from 'vuestic-ui'
  import { getNextMaintenance, getNumberAreasRestritas, getNumberDevices, getNumberEvents } from './stats'
  import { NEXT_MAINTENANCE } from '../../../services/backend-api/interfaces'

  const { t } = useI18n()
  const { colors } = useColors()

  let alarmTriggered = ref(false)
  let isArmed = ref(true)

  // why component disappear with this?
  const nextMaintenanceList = ref(await formatMaintenanceList());
  /*const nextMaintenanceList = [
                                { Man_inicio : "2023-06-30",
                                  Man_duracao: "24",
                                  AR_localizacao: "Edifício A, 3º Andar"
                                },
                                { Man_inicio : "2023-07-01",
                                  Man_duracao: "48",
                                  AR_localizacao: "Edifício B, 2º Andar"
                                },
                            ]*/

  const infoTiles = ref([
    {
      color: 'success',
      value: ref((await getNumberDevices())[0]['row_count']),
      text: 'Dispositivos',
      icon: '',
    },
    {
      color: '#EF6C00',
      value: ref((await getNumberEvents())[0]['row_count']),
      text: 'Eventos',
      icon: '',
    },
    {
      color: '#004D40',
      value: ref((await getNumberAreasRestritas())[0]['row_count']),
      text: 'Áreas Restritas',
      icon: '',
    },
  ])

  async function formatMaintenanceList() {
    const main = await getNextMaintenance();

    const res: any[] = [];

    main.forEach(MAN => {
      let dInicio = formatDate(MAN.Man_inicio);
      let local = MAN.AR_localizacao;
      let duracao = time_between_dates(MAN.Man_inicio, MAN.Man_fim)
      console.log(time_between_dates(MAN.Man_inicio, MAN.Man_fim))
      res.push({Man_inicio: dInicio, Man_duracao: duracao, AR_localizacao:local})
    });

    return res;
  };

  function time_between_dates(dateS1: string, dateS2: string): number {
    const ONE_DAY_IN_MS = 24 * 60 * 60 * 1000; // Number of milliseconds in a day

    const date1 = new Date(dateS1);
    const date2 = new Date(dateS2);

    if (date1.getTime() === date2.getTime()) {
      // If the dates are equal, return 24 hours (1 day)
      return 24;
    } else if (date2 > date1) {
      // If date2 is greater than date1, calculate the time difference in milliseconds
      const timeDiffInMs = date2.getTime() - date1.getTime();
      const hoursDiff = Math.ceil(timeDiffInMs / (1000 * 60 * 60)); // Convert milliseconds to hours and round up
      return hoursDiff;
    } else {
      // Invalid input, date2 is not greater than or equal to date1
      throw new Error("Invalid input: date2 should be greater than or equal to date1.");
    }
  }


  function formatDate(dateString: string): String{
    const date = new Date(dateString);

    const isoDateString = date.toISOString();
    const formattedDate = isoDateString.slice(8, 10) + '-' + isoDateString.slice(5, 7) + '-' + isoDateString.slice(0, 4);

    return formattedDate
  }

  function toggleArmedStatus() {
    isArmed.value = !isArmed.value;
    alarmTriggered.value = false
  }

  function triggerAlarm(){
    if(isArmed.value)
      alarmTriggered.value = true
  }

  function getSystemStatus(): String {
    if (alarmTriggered.value)
      return 'Acionado';
    else if (isArmed.value)
      return 'Armado'
    else
      return 'Desarmado'
  }

  function getSystemDescription(): String {
    if (alarmTriggered.value)
      return 'O alarme acabou de ser acionado, por favor verifique a Área Restrita e o dispositivo';
    else if (isArmed.value)
      return 'O alarme está Armado e a Funcionar';
    else
      return 'O alarme encontra-se Desarmado e não será ativado. Por favor pressione para Armar, para proteger a sua área'
  }
</script>

<style lang="scss" scoped>
  .row-separated {
    .flex + .flex {
      border-left: 1px solid var(--va-background-primary);
    }
  }

  .rich-theme-card-text {
    line-height: 1.5;
  }

  .gallery-carousel {
    width: 80vw;
    max-width: 100%;

    @media all and (max-width: 576px) {
      width: 100%;
    }
  }

  .system-arm-section {
    display: flex;
    justify-content: center;
    align-items: center;
  }

  .outer-button {
    position: relative;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    width: 240px;
    height: 220px;
    border-radius: 50%;
    font-size: 18px;
    font-weight: bold;
    border: none;
    cursor: pointer;
    transition: background-color 0.3s;
  }

  /* Updated CSS for the outer button */
  .outer-button::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    border-radius: 50%;
    background-color: transparent;
    z-index: -1;
  }

  .inner-button {
    position: absolute;
    top: 25%;
    left: 25%;
    width: 50%;
    height: 50%;
    border-radius: 50%;
    color: white;
    font-size: 18px;
    font-weight: bold;
    border: none;
    cursor: pointer;
    transition: background-color 0.3s;
  }

  .armed .inner-button {
    background-color: green;
  }

  .armed .outer-button {
    background-color: green;
  }
  .triggered .outer-button {
    background-color: red;
  }

  .disarmed .inner-button {
    background-color: grey;
  }

  .disarmed .outer-button {
    background-color: grey;
  }

  .triggered .inner-button {
    background-color: red;
  }

  .armed span {
    color: green;
  }

  .disarmed span {
    color: grey;
  }

  .triggered span {
    color: red;
  }

  .outer-button:hover {
    opacity: 0.8;
  }

  .outer-button:focus {
    outline: none;
  }
</style>
