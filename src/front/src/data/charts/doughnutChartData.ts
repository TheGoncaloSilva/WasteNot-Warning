import { TDoughnutChartData } from '../types'
import { BE_API } from '../../services/backend-api/backend-api'


export const doughnutChartData: TDoughnutChartData = {
  labels: ['North America', 'South America', 'Australia'],
  datasets: [
    {
      label: 'Population (millions)',
      backgroundColor: ['danger', 'info', 'primary'],
      data: [2478, 5267, 734],
    },
  ],
}

export const getDoughnutChartData = async () => {

  return await (async() => {
    const nExcluded = await BE_API.getNumberOfEventsInExcludedTime();
    const nMaintenance = await BE_API.getNumberOfEventsInMaintenance();
    const nActive = await BE_API.getNumberOfEventsInActiveSchedule();
    let doughnutChartData: TDoughnutChartData = {
      labels: ['Sistema ativado', 'Sistema em manutenção', 'Sistema Desarmado'],
      datasets: [
        {
          label: "Número de Ocorrências",
          backgroundColor: ['danger', 'info', 'primary'],
          data: [nActive[0]['row_count'], nMaintenance[0]['row_count'], nExcluded[0]['row_count']],
        }
      ]
    };
  
    return doughnutChartData;
  })();
};
