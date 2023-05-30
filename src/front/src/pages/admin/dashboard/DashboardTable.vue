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
      </va-card-content>
    </va-card>
</template>

<script setup lang="ts">
  import { ref, onMounted, onBeforeUnmount } from 'vue'
  import { useI18n } from 'vue-i18n'
  import data from '../../../data/tables/markup-table/data.json'
  import { getEventList } from './stats'

  const { t } = useI18n()

  let events = ref(await getEventList());
  let elapsedTime = ref(0)
  let intervalId: any = null

  function startTimer() {
    intervalId = setInterval(() => {
      elapsedTime.value += 10; // Increment elapsed time by 10 seconds
      // Call your desired function here
      myFunction();
    }, 10000); // 10000 milliseconds = 10 seconds
  }

  function stopTimer() {
    clearInterval(intervalId);
  }

  function myFunction() {
    // Perform the desired action here
    getEventList().then((res: any[]) => {
      events = ref(res);
    });
  }

  onMounted(() => {
    startTimer();
  });

  onBeforeUnmount(() => {
    stopTimer();
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
