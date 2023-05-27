<script lang="ts">
import { ref, onMounted } from 'vue'
import { BE_API } from '../../../services/backend-api/backend-api'
import { UTILIZADOR } from '../../../services/backend-api/interfaces';

export default {
  
  data() {
    return {
      users: [] as UTILIZADOR[]
    }
  }
  ,
  mounted() {
    (async() => {
      this.users = await BE_API.getUsers();
    })();
  }
}
</script>

<template>


<va-card class="flex mb-4">
      <va-card-title>Users list</va-card-title>
      
      <va-card-content>
        <div class="table-wrapper">
          <table class="va-table va-table--striped va-table--hoverable">
            <thead>
              <tr>
                <th>Nome</th>
                <th>Telefone</th>
                <th>Data de Nascimento</th>
                <th>Nivel permissão</th>
              </tr>
            </thead>

            <tbody>
              <tr v-for="user in users">
                <td>{{ user.Nome }}</td>
                <td>{{ user.Telefone }}</td>
                <td>{{ user.DataNascimento }}</td>
                <td>{{ user.NivelPermissao_Nivel }}</td>
              </tr>
            </tbody>
          </table>
        </div>
      </va-card-content>
    </va-card>


</template>

<style>


    .va-table {
      width: 100%;
    }
  
</style>