<script lang="ts">
import { ref, onMounted } from 'vue'
import { BE_API } from '../../../services/backend-api/backend-api'
import { UTILIZADOR , LAST_USER_EVENTS, AREA_RESTRITA} from '../../../services/backend-api/interfaces';


export default {
  data() {
    return {
        basicAccordionValue: [] as any
    }
  },
  async mounted() {

  },
  methods: {
  }
}
</script>



<template>
      <div class="flex xs12">
        <va-card>
          <va-card-title>Áreas restritas</va-card-title>
          <va-card-content>
            <va-accordion v-model="basicAccordionValue">
              <va-collapse header="123">
                <div class="pa-3">
                  <p class="va-h3">123</p>
                  <div>
                    123
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