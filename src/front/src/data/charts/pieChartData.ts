import { BE_API } from '../../services/backend-api/backend-api';
import { TLineChartData } from '../types'

export const pieChartData: TLineChartData = {
  labels: ['Africa', 'Asia', 'Europe'],
  datasets: [
    {
      label: 'Population (millions)',
      backgroundColor: ['primary', 'warning', 'danger'],
      data: [2478, 5267, 734],
    },
  ],
}

export const getPieChartData = async () => {

  return await (async() => {
    const res = await BE_API.getEventsCountByCategory();
    let doughnutChartData: TLineChartData = {
      labels: [],
      datasets: [
        {
          label: "total",
          backgroundColor: [
          "#E74C3C", // Red
          "#3498DB", // Blue
          "#2ECC71", // Green
          "#F1C40F", // Yellow
          "#9B59B6", // Purple
          "#1ABC9C", // Turquoise
          "#E67E22", // Orange
          "#27AE60", // Dark Green
          "#D35400", // Burnt Orange
          "#8E44AD", // Violet
          "#C0392B", // Maroon
          "#16A085"  // Teal],
          ],
          data: [],
        }
      ]
    };
    res.forEach(el => {
      doughnutChartData.labels?.push(el.TipoEvento_Descricao);
      doughnutChartData.datasets[0].data.push(el.neventos);
    });
  
    return doughnutChartData;
  })();
};