<template>
  <div class="dashboard">
    <Suspense>
      <dashboard-info-block />
    </Suspense>

    <Suspense>
      <dashboard-charts />
    </Suspense>
    
    <!--<div class="row row-equal">
      
      <Suspense>
        <div class="flex xs12 lg6">
          <DashboardTable/>
        </div>
      </Suspense>

    </div>-->
  </div>
</template>

<script setup lang="ts">
  import { ref } from 'vue'

  import DashboardCharts from './DashboardCharts.vue'
  import DashboardInfoBlock from './DashboardInfoBlock.vue'

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
