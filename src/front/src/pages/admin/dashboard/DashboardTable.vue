<template>
    <va-card>
      <va-card-title>Lista de últimos eventos</va-card-title>
      <va-card-content>
        <div class="table-wrapper">
          <table class="va-table va-table--striped va-table--hoverable" style="width: 100%;">
            <thead>
              <tr>
                <th>TimeStamp</th>
                <th>Tipo de Registo</th>
                <th>Mac Dispositivo</th>
                <th>Localização</th>
              </tr>
            </thead>

            <tbody>
              <tr v-for="event in events" :key="event.Reg_id">
                <td>{{ event.Reg_timestamp }}</td>
                <td>{{ event.Reg_tipo }}</td>
                <td>{{ event.Disp_mac }}</td>
                <td>{{ event.AR_localizacao }}</td>
                <!--<td>
                  <va-badge :text="event.status" :color="getStatusColor(event.status)" />
                </td>-->
              </tr>
            </tbody>
          </table>
        </div>
          <div class="flex xs12 xm6">
              <va-pagination v-model="activePage" :visible-pages="3" :pages="numberPages" />
          </div>
      </va-card-content>
    </va-card>
</template>

<script setup lang="ts">
  import { ref, onMounted, onBeforeUnmount, watch } from 'vue'
  import { useI18n } from 'vue-i18n'
  import { getEventList, get_paginated_Events } from './stats'
  import { getNumberEvents } from './stats';
import { EVENT_LIST } from '../../../services/backend-api/interfaces';

  const { t } = useI18n()

  let elapsedTime = ref(0)
  let intervalId: any = null
  const numberOfEventsPerPage: number = 9;
  let numberPages = ref(Math.ceil((await getNumberEvents())[0]['row_count']/numberOfEventsPerPage))
  const activePage = ref(1)
  //let events = ref(await getEventList());
  let events = ref();

  function startTimer() {
    intervalId = setInterval(() => {
      elapsedTime.value += 10; // Increment elapsed time by 10 seconds
      // Call your desired function here
      paginated();
    }, 10000); // 10000 milliseconds = 10 seconds
  }

  function stopTimer() {
    clearInterval(intervalId);
  }

  function paginated(){
    const offset = (activePage.value - 1) * numberOfEventsPerPage;
    get_paginated_Events(offset, numberOfEventsPerPage).then((res: EVENT_LIST[]) => {
      events.value = res;
    })
  }

  onMounted(() => {
    paginated();
    startTimer();
  });

  onBeforeUnmount(() => {
    stopTimer();
  });

  watch(activePage, (newPage, oldPage) => {
    paginated();
  });

</script>

<style lang="scss">
  .markup-tables {
    .table-wrapper {
      overflow: auto;
    }

    .va-table {
      width: 100%;
    }
  }
</style>
