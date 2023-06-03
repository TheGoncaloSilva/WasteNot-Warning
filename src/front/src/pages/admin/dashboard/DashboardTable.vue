<template>
    <va-card>
      <va-card-title>
        Lista de últimos eventos
        <va-button-dropdown 
          icon="fa-filter" 
          plain 
          class="mr-2 mb-2"
          round
        >
          <va-dropdown-content class="language-dropdown__content pl-4 pr-4 pt-2 pb-2">
              <div
                v-for="(opt, idx) in filterOptions"
                :key="opt.value"
                class="language-dropdown__item row align--center pt-1 pb-1 mt-2 mb-2"
                :default="defOption"
                @click="filterEvent(opt.value)"
              >
                <span class="dropdown-item__text" style="font-weight:bold;color:blue;" v-if="opt.value == defOption">
                  {{ opt.label }}
                </span>
                <span class="dropdown-item__text" v-else>
                  {{ opt.label }}
                </span>
              </div>
            </va-dropdown-content>
        
        </va-button-dropdown>

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
          <div class="flex xs12 md12">
              <va-pagination v-model="activePage" :visible-pages="3" :pages="numberPages" />
          </div>
        </div>
      </va-card-content>
    </va-card>
</template>

<script setup lang="ts">
  import { ref, onMounted, onBeforeUnmount, watch } from 'vue'
  import { useI18n } from 'vue-i18n'
  import { getEventList, getNumberActivatedEvents, getNumberExcludedEvents, getNumberMaintenanceEvents, get_paginated_Events } from './stats'
  import { getNumberEvents } from './stats';
  import { EVENT_LIST, NUMBER_STATS } from '../../../services/backend-api/interfaces';
import { useColors } from 'vuestic-ui';

  const { colors } = useColors()
  const { t, locale } = useI18n()

  let elapsedTime = ref(0)
  let intervalId: any = null
  const numberOfEventsPerPage: number = 9;
  let numberPages = ref(Math.ceil((await getNumberEvents())[0]['row_count']/numberOfEventsPerPage))
  let activePage = ref(1)
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
    get_paginated_Events(offset, numberOfEventsPerPage, defOption.value).then((res: EVENT_LIST[]) => {
      events.value = res;
      if(defOption.value == 'all'){
        //let numberPages = ref(Math.ceil((await getNumberEvents())[0]['row_count']/numberOfEventsPerPage))
        getNumberEvents().then((res: NUMBER_STATS[]) => {
          numberPages.value = Math.ceil((res[0]['row_count']/numberOfEventsPerPage));
          })
      }else if(defOption.value == 'active'){
        //let numberPages = ref(Math.ceil((await getNumberEvents())[0]['row_count']/numberOfEventsPerPage))
        getNumberActivatedEvents().then((res: NUMBER_STATS[]) => {
          numberPages.value = Math.ceil((res[0]['row_count']/numberOfEventsPerPage));
        })
      }else if(defOption.value == 'excluded'){
        //let numberPages = ref(Math.ceil((await getNumberEvents())[0]['row_count']/numberOfEventsPerPage))
        getNumberExcludedEvents().then((res: NUMBER_STATS[]) => {
          numberPages.value = Math.ceil((res[0]['row_count']/numberOfEventsPerPage));
        })
      }else if(defOption.value == 'maintenance'){
        //let numberPages = ref(Math.ceil((await getNumberEvents())[0]['row_count']/numberOfEventsPerPage))
        getNumberMaintenanceEvents().then((res: NUMBER_STATS[]) => {
          numberPages.value = Math.ceil((res[0]['row_count']/numberOfEventsPerPage));
        })
      }

    })
  }

  function filterEvent(rule: any) {
    defOption.value = rule;
    paginated();
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

  .language-dropdown {
    cursor: pointer;

    &__content {
      .fi-size-small {
        min-width: 1.5rem;
        min-height: 1.5rem;
        margin-right: 0.5rem;
      }
    }

    &__item {
      padding-bottom: 0.625rem;
      cursor: pointer;
      flex-wrap: nowrap;

      &:last-of-type {
        padding-bottom: 0 !important;
      }

      &:hover {
        color: var(--va-primary);
      }
    }

    .fi::before {
      content: '';
    }

    .fi-size-large {
      display: block;
      width: 32px;
      height: 24px;
    }

    .va-dropdown__anchor {
      display: inline-block;
    }
  }
</style>
