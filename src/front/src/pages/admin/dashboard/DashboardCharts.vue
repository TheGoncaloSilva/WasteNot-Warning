<template>

  <div class="row row-equal">
    <div class="flex xs12 lg6 xl6">
        <DashboardTable/>
    </div>

    <div class="flex xs12 sm6 md6 lg3 xl3">
      <va-card class="d-flex">
        <va-card-title>
          <h1>Estatísticas das ocorrências</h1>
        </va-card-title>
        <va-card-content v-if="doughnutChartDataGenerated">
          <va-chart ref="doughnutChart" class="chart chart--donut" :data="doughnutChartDataGenerated" type="doughnut" />
        </va-card-content>
      </va-card>
    </div>

    <div class="flex xs12 sm6 md6 lg3 xl3">
      <va-card class="d-flex">
        <va-card-title>
          <h1>Distribuição de eventos</h1>
        </va-card-title>

          <va-card-content v-if="pieChartDataGenerated">
              <va-chart ref="pieChart" class="chart chart--pie" :data="pieChartDataGenerated" type="pie" />
          </va-card-content>

      </va-card>
    </div>

  </div>

</template>

<script setup lang="ts">
  import { ref } from 'vue'
  import { useI18n } from 'vue-i18n'
  import { getDoughnutChartData, lineChartData, getPieChartData } from '../../../data/charts'
  import { useChartData } from '../../../data/charts/composables/useChartData'
  import { usePartOfChartData } from './composables/usePartOfChartData'
  import VaChart from '../../../components/va-charts/VaChart.vue'
  import DashboardTable from './DashboardTable.vue'


  const { t } = useI18n()

  const dataGenerated = useChartData(lineChartData, 0.7)
  const doughnutChartDataGenerated = useChartData(await getDoughnutChartData())
  const pieChartDataGenerated = useChartData(await getPieChartData())
  
  const {
    dataComputed: lineChartDataGenerated,
    minIndex,
    maxIndex,
    datasetIndex,
    setDatasetIndex,
  } = usePartOfChartData(dataGenerated)

  
</script>

<style scoped>
  .chart {
    height: 400px;
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
    width: 270px;
    height: 270px;
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
