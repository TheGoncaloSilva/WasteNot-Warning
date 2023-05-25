<script setup lang="ts">
  import { ref } from 'vue'
  import { useI18n } from 'vue-i18n'
  import data from '../../../data/tables/markup-table/data.json'

  const { t } = useI18n()

  const users = ref(data.slice(0, 8))

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
              <tr v-for="user in users" :key="user.id">
                <td>{{ user.name }}</td>
                <td>{{ user.email }}</td>
                <td>{{ user.country }}</td>
                <td>
                  <va-badge :text="user.status" :color="getStatusColor(user.status)" />
                </td>
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