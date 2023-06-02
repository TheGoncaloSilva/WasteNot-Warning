<template>
    <va-card>
      <va-card-title>
        Lista de últimos eventos
        <!--<va-button-dropdown 
          icon="fa-filter" 
          plain 
          class="mr-2 mb-2"
          round
          :default="items"
        >
        <template v-slot:default>
          <va-button-dropdown-item label="Option 1"></va-button-dropdown-item>
          <va-button-dropdown-item label="Option 2"></va-button-dropdown-item>
          <va-button-dropdown-item label="Option 3"></va-button-dropdown-item>
        </template>
        </va-button-dropdown>-->

      </va-card-title>
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
        <div class="row">
          <div class="flex xs12 md4">
              <va-pagination v-model="activePage" :visible-pages="3" :pages="numberPages" />
          </div>
          <div class="flex xs12 md2">
            <span>Filter by:</span>
          </div>
          <div class="grid xs12 md6">
            <va-button-toggle
              v-model="defOption"
              preset="outline"
              :options="filterOptions"
              border-color="info"
              round
              :click="filterEvent"
            />
          </div>
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

  const filterOptions = ref([
    { label: 'Tudo', value: 'all' },
    { label: 'Acionados', value: 'active' },
    { label: 'Excluídos', value: 'excluded' },
    { label: 'Manutenção', value: 'maintenance' },
  ])
  const defOption = ref('all')


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

  function filterEvent(rule: string) {
    console.log(rule)
  };


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

  .va-dropdown-item {
    display: block;
    padding: 0.5rem 1rem;
    clear: both;
    font-weight: normal;
    color: #212529;
    text-align: inherit;
    white-space: nowrap;
    background-color: transparent;
    border: 0;
  }
</style>
