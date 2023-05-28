<template>
    <va-card>
      <va-card-title>Lista de últimos eventos</va-card-title>
      <va-card-content>
        <div class="table-wrapper">
          <table class="va-table va-table--striped va-table--hoverable">
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
  import { ref } from 'vue'
  import { useI18n } from 'vue-i18n'
  import data from '../../../data/tables/markup-table/data.json'
  import { getEventList } from './stats'

  const { t } = useI18n()

  const users = ref(data.slice(0, 8))
  const events = ref(await getEventList());

  function getStatusColor(status: string) {
    if (status === 'paid') {
      return 'success'
    }

    if (status === 'processing') {
      return 'info'
    }

    return 'danger'
  }
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
