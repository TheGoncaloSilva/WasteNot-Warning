<template>
  <div class="dashboard">
    <Suspense>
      <dashboard-charts />
    </Suspense>
    
    <Suspense>
      <dashboard-info-block />
    </Suspense>
    
    <div class="row row-equal">
      
      <Suspense>
        <div class="flex xs12 lg6">
          <DashboardTable/>
        </div>
      </Suspense>

      <div class="flex xs12 lg6">
        <dashboard-tabs @submit="addAddressToMap" />
      </div>

    </div>
  </div>
</template>

<script setup lang="ts">
  import { ref } from 'vue'

  import DashboardCharts from './DashboardCharts.vue'
  import DashboardInfoBlock from './DashboardInfoBlock.vue'
  import DashboardTabs from './DashboardTabs.vue'
  import DashboardTable from './DashboardTable.vue'

  const dashboardMap = ref()

  function addAddressToMap({ city, country }: { city: { text: string }; country: string }) {
    dashboardMap.value.addAddress({ city: city.text, country })
  }
</script>

<style lang="scss">
  .row-equal .flex {
    .va-card {
      height: 100%;
    }
  }

  .dashboard {
    .va-card {
      margin-bottom: 0 !important;
      &__title {
        display: flex;
        justify-content: space-between;
      }
    }
  }
</style>
