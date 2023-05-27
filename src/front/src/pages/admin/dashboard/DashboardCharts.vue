<template>
  <div class="row row-equal">
    <div class="flex xs12 lg6 xl6">
      <va-card v-if="lineChartDataGenerated">
        <va-card-title>
          <h1>Event History</h1>
          <div>
            <va-button
              class="ma-1"
              size="small"
              color="danger"
              :disabled="datasetIndex === minIndex"
              @click="setDatasetIndex(datasetIndex - 1)"
            >
              {{ t('dashboard.charts.showInLessDetail') }}
            </va-button>
            <va-button
              class="ma-1"
              size="small"
              color="danger"
              :disabled="datasetIndex === maxIndex - 1"
              @click="setDatasetIndex(datasetIndex + 1)"
            >
              {{ t('dashboard.charts.showInMoreDetail') }}
            </va-button>
          </div>
        </va-card-title>
        <va-card-content>
          <va-chart class="chart" :data="lineChartDataGenerated" type="line" />
        </va-card-content>
      </va-card>
    </div>

    <div class="flex xs12 sm6 md6 lg3 xl3">
      <va-card class="d-flex">
        <va-card-title>
          <h1>{{ t('dashboard.charts.loadingSpeed') }}</h1>
          <va-button icon="print" plain @click="printChart" />
        </va-card-title>
        <va-card-content v-if="doughnutChartDataGenerated">
          <va-chart ref="doughnutChart" class="chart chart--donut" :data="doughnutChartDataGenerated" type="doughnut" />
        </va-card-content>
      </va-card>
    </div>

    <div class="flex xs12 sm6 md6 lg3 xl3">
      <va-card class="d-flex">
        <va-card-title>
          <h1>{{ t('dashboard.charts.loadingSpeed') }}</h1>
          <va-button icon="print" plain @click="printChart" />
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
  import { doughnutChartData, lineChartData, pieChartData } from '../../../data/charts'
  import { useChartData } from '../../../data/charts/composables/useChartData'
  import { usePartOfChartData } from './composables/usePartOfChartData'
  import VaChart from '../../../components/va-charts/VaChart.vue'

  const { t } = useI18n()

  const dataGenerated = useChartData(lineChartData, 0.7)
  const doughnutChartDataGenerated = useChartData(doughnutChartData)
  const pieChartDataGenerated = useChartData(pieChartData)
  
  const {
    dataComputed: lineChartDataGenerated,
    minIndex,
    maxIndex,
    datasetIndex,
    setDatasetIndex,
  } = usePartOfChartData(dataGenerated)

  function printChart() {
    const windowObjectReference = window.open('', 'Print', 'height=600,width=800') as Window

    const img = windowObjectReference.document.createElement('img')

    img.src = `${(document.querySelector('.chart--donut canvas') as HTMLCanvasElement | undefined)?.toDataURL(
      'image/png',
    )}`

    img.onload = () => {
      windowObjectReference?.document.body.appendChild(img)
    }

    windowObjectReference.print()

    windowObjectReference.onafterprint = () => {
      windowObjectReference?.close()
    }
  }
  
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
