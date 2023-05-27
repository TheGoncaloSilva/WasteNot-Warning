<script lang="ts">
import { ref, onMounted } from 'vue'
import { BE_API } from '../../../services/backend-api/backend-api'
import { UTILIZADOR , LAST_USER_EVENTS, AREA_RESTRITA} from '../../../services/backend-api/interfaces';


export default {
  data() {
    return {
      users: [] as UTILIZADOR[],
      showNewUserDialog: false,
      selected_user: null,
      lastEvents: [] as LAST_USER_EVENTS[],
      areasRestritas: [] as AREA_RESTRITA[],
      permission_level: {id: 1, description: 'administrador'},
      newUser: {
        Nome: '',
        Telefone: 0,
        DataNascimento: new Date(),
        NivelPermissao_Nivel: '',
        Password: ''
        
      },
      showUserInfoDialog: false,
        nivel_permissao_options: [
    {
      id: 1,
      description: 'administrador',
    },
    {
      id: 2,
      description: 'utilizador externo',
    },
    {
      id: 3,
      description: 'utilizador comum',
    },
    ]
    }
  },
  async mounted() {
    try {
      this.users = await BE_API.getUsers();
    } catch (error) {
      console.error('Error retrieving users:', error);
    }
  },
  methods: {

    remove(usrid: number)
    {
      (async() => {
        await BE_API.removeUser(usrid);
        const index = this.users.findIndex((user) => user.Id === usrid);
        if (index !== -1) {
        this.users.splice(index, 1);
      }
      })();
    },
    viewDetails(user: UTILIZADOR)
    {
      this.lastEvents = [];
      this.areasRestritas = [];
      (async() => {
        // @ts-ignore
        this.selected_user = user;
        
        this.showUserInfoDialog = true;
        
        this.lastEvents = await BE_API.getUserLastEvents(user.Id, 50);
        this.areasRestritas = await BE_API.getUserRestrictedAreas(user.Id);
          
      })();
    },

    async addUser() {
      // Validate and process the new user data
      if (this.validateUser(this.newUser)) {
        try {
          this.newUser.NivelPermissao_Nivel = this.permission_level.description;
          const response = await BE_API.addUser(this.newUser);
          // Assuming the response contains the newly added user
          //this.users.push(response);
          this.showNewUserDialog = false;
          this.clearNewUser();
          this.users = await BE_API.getUsers();
        } catch (error) {
          console.error('Error adding user:', error);
        }
      }
    },
    cancelAddUser() {
      this.showNewUserDialog = false;
      this.clearNewUser();
    },
    validateUser(user: any) {
      // Perform validation on the new user data
      // Add your validation logic here
      // Return true if the user data is valid, false otherwise
      return true;
    },
    clearNewUser() {
      // Clear the new user data
      this.newUser = {
        Nome: '',
        Telefone: 0,
        DataNascimento: new Date(),
        NivelPermissao_Nivel: '',
        Password: ''
      };
    }
  }
}
</script>








<template>
  <div>

    <va-modal v-model="showNewUserDialog" @ok="addUser">
      <va-card style="min-height:400px">
        <va-card-title>Add New User</va-card-title>
        <va-card-content>
          <!-- Add form fields to capture new user data -->
          <va-input v-model="newUser.Nome" placeholder="Nome" />
          <div style="height:8px"></div>
          <va-input v-model="newUser.Telefone" type="number" placeholder="Telefone" />
          <div style="height:8px"></div>
          <va-date-input label="Data de nascimento" v-model="newUser.DataNascimento" />
          <div style="height:8px"></div> 
              <va-select
                    label="Nivel permissão"
                    text-by="description"
                    v-model="permission_level"
                    track-by="id"
                    :options="nivel_permissao_options"
                  />
          <div style="height:8px"></div>
          <va-input label="Password" type="password" v-model="newUser.Password" />
        </va-card-content>

        
      </va-card>
    </va-modal>
    <va-modal v-model="showUserInfoDialog" @ok="addUser">
  <va-card style="min-height:400px; min-width: 500px;">
    <va-card-title>Informações do utilizador</va-card-title>
    <va-card-content>

    
      <!--<va-table :data="lastEvents" :columns="['a','b','c','d']"></va-table>

      
      <h3>Áreas Restritas</h3>
      <va-table :data="areasRestritas" :columns="['a','b','c','d']"></va-table>
      -->

      <va-card class="flex mb-4">
      <va-card-title>Últimos eventos do utilizador(a) {{ selected_user ? selected_user["Nome"] : "" }}</va-card-title>
      
      <va-card-content>
      <div class="table-wrapper">
        <table class="va-table va-table--striped va-table--hoverable">
          <thead>
            <tr>
              <th>Timestamp</th>
              <th>Tipo do evento</th>
              <th>Dispositivo Mac</th>
              <th>Dispositivo Modelo</th>
              <th>Dispositivo Fabricante</th>
            </tr>
          </thead>
  
          <tbody>
            <tr v-for="event in lastEvents" :key="event.Id">
              <td>{{ event.Timestamp }}</td>
              <td>{{ event.TipoEvento_Descricao }}</td>
              <td>{{ event.Mac }}</td>
              <td>{{ event.Modelo}}</td>
              <td>{{ event.Fabricante }}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </va-card-content>
    </va-card>

    <va-card class="flex mb-4">
      <va-card-title>Áreas restritas do utilizador(a) {{ selected_user ? selected_user["Nome"] : "" }}</va-card-title>
      
      <va-card-content>
      <div class="table-wrapper">
        <table class="va-table va-table--striped va-table--hoverable">
          <thead>
            <tr>
              <th>ID</th>
              <th>Descrição</th>
              <th>Localização</th>

            </tr>
          </thead>
  
          <tbody>
            <tr v-for="area in areasRestritas" :key="area.Id">
              <td>{{ area.Id }}</td>
              <td>{{ area.DESCRICAO }}</td>
              <td>{{ area.LOCALIZACAO }}</td>
            </tr>

          </tbody>
        </table>
      </div>
    </va-card-content>
    </va-card>

      
    </va-card-content>
  </va-card>
</va-modal>
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
              <th>Actions</th>

            </tr>
          </thead>
  
          <tbody>
            <tr v-for="user in users" :key="user.Id">
              <td>{{ user.Nome }}</td>
              <td>{{ user.Telefone }}</td>
              <td>{{ user.DataNascimento }}</td>
              <td>{{ user.NivelPermissao_Nivel }}</td>
              <td><span><va-icon @click="viewDetails(user)" name="edit" color="warning" style="margin-right: 10px">info</va-icon><va-icon @click="remove(user.Id)" name="remove" color="danger">delete</va-icon></span></td>
            </tr>

          </tbody>
        </table>
      </div>
    </va-card-content>
      
      <va-card-actions>
        <va-button @click="showNewUserDialog = true">New User</va-button>
      </va-card-actions>
    </va-card>
  </div>
</template>

<style>


    .va-table {
      width: 100%;
    }
  
</style>