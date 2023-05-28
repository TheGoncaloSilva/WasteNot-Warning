<script lang="ts">
import { ref, onMounted } from 'vue'
import { BE_API } from '../../../services/backend-api/backend-api'
import { UTILIZADOR , LAST_USER_EVENTS, AREA_RESTRITA, SECURITY_DEVICE, LAST_REPAIRS, HORARIO_MONITORIZACAO} from '../../../services/backend-api/interfaces';
import { toHandlers } from 'vue';


export default {
  data() {
    return {
        basicAccordionValue: [] as any,
        restrictedAreas: [] as AREA_RESTRITA[],
        devices: {} as { [key: number]: SECURITY_DEVICE[] },
        horarios: {} as { [key: number]: HORARIO_MONITORIZACAO[]},
        last_repairs: {} as {[key: number]: LAST_REPAIRS[]},
    }
  },
  async mounted() {
    this.restrictedAreas = await BE_API.get_restricted_areas();

    this.restrictedAreas.forEach(area => {
      this.devices[area.Id] = [];
      this.horarios[area.Id] = [];
      this.last_repairs[area.Id] = [];
    });
  },
  methods: {
    accordionClicked(area: AREA_RESTRITA)
    {
      console.log(this.horarios);
      (async() => {
        if(this.devices[area.Id].length === 0)
        {
          const _devices = await BE_API.get_restricted_area_devices(area.Id);
          this.devices[area.Id] = _devices;
        }
        if(this.last_repairs[area.Id].length === 0)
        {
          const _last_repairs = await BE_API.get_resticted_area_last_repairs(area.Id, 10);
          this.last_repairs[area.Id] = _last_repairs;
        }
        if(this.horarios[area.Id].length === 0)
        {
          const _horarios = await BE_API.get_restricted_area_horario(area.Id);
          this.horarios[area.Id] = _horarios;
        }
      })();
    }
  }
}
</script>



<template>
      <div class="flex xs12">
        <va-card>

          <va-card-title>Áreas restritas</va-card-title>
          <va-card-content>
            <va-accordion v-model="basicAccordionValue[idx]" v-for="area,idx of restrictedAreas" @click="accordionClicked(area)" style="padding:5px">
              <va-collapse :header="area.DESCRICAO">
                <div class="pa-3">
                  <p class="va-h5">{{ area.LOCALIZACAO }}</p>
                  <div>
                    <va-card class="flex mb-4">
                    <va-card-title>Dispositivos da área Restrita</va-card-title>
                    
                    <va-card-content>
                    <div class="table-wrapper">
                      <table class="va-table va-table--striped va-table--hoverable">
                        <thead>
                          <tr>
                            <th>Mac do dispositivo</th>
                            <th>Tipo do dispositivo</th>
                          </tr>
                        </thead>
                
                        <tbody>
                          <tr v-for="device in devices[area.Id]" :key="device.Dispositivo_Mac">
                            <td>{{ device.Dispositivo_Mac }}</td>
                            <td>{{ device.TipoDispositivoSeguranca_Descricao }}</td>
                          </tr>
                        </tbody>
                      </table>
                    </div>
                  </va-card-content>
                  </va-card>

                  <va-card class="flex mb-4">
                    <va-card-title>Últimas manutenções</va-card-title>
                    
                    <va-card-content>
                    <div class="table-wrapper">
                      <table class="va-table va-table--striped va-table--hoverable">
                        <thead>
                          <tr>
                            <th>Data de início</th>
                            <th>Data de fim</th>
                            <th>Comentário</th>
                            <th>Estado da manutenção</th>
                          </tr>
                        </thead>
                
                        <tbody>
                          <tr v-for="last_repair in last_repairs[area.Id]">
                            <td>{{ last_repair.DataInicio }}</td>
                            <td>{{ last_repair.DataFim }}</td>
                            <td>{{ last_repair.Comentatio}}</td>
                            <td>{{ last_repair.EstadoManutencao_Descricao }}</td>
                          </tr>
                        </tbody>
                      </table>
                    </div>
                  </va-card-content>
                  </va-card>


                  <va-card class="flex mb-4">
                    <va-card-title>Horários de monitorização</va-card-title>
                    
                    <va-card-content>
                    <div class="table-wrapper">
                      <table class="va-table va-table--striped va-table--hoverable">
                        <thead>
                          <tr>
                            <th>Hora de início</th>
                            <th>Hora de fim</th>
                            <th>Estado</th>
                          </tr>
                        </thead>
                
                        <tbody>
                          <tr v-for="horario in horarios[area.Id]">
                            <td>{{ horario.HoraInicio }}</td>
                            <td>{{ horario.HoraFim }}</td>
                            <td>{{ Number(horario.Estado) === 0 ? 'Inativo' : 'Ativo'}}</td>
                            
                          </tr>
                        </tbody>
                      </table>
                    </div>
                  </va-card-content>
                  </va-card>


                  </div>
                </div>
              </va-collapse>
            </va-accordion>
          </va-card-content>
        </va-card>
      </div>
</template>

<style>


    .va-table {
      width: 100%;
    }
  
</style>