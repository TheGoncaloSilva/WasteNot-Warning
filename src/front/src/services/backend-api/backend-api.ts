import axios, { AxiosResponse } from 'axios';
import { EVENTS_COUNT_BY_CATEGORY, LAST_USER_EVENTS, NEXT_MAINTENANCE, NUMBER_STATS, UTILIZADOR } from './interfaces';
import router from '../../router';

class BaseCommunication {
    private baseURL: string;
  


    constructor(baseURL: string, logs: boolean = true) {
      this.baseURL = baseURL;
    }

    private get_access_token()
    {
      return `Bearer ${localStorage.getItem('auth-token')}`
    }


    async get(endpoint: string, ...params: string[]): Promise<any> {
      let url = `${this.baseURL}/${endpoint}`;
    
      // Append query parameters to the URL
      if (params.length > 0) {
        const queryParams = params.join('&');
        url += `?${queryParams}`;
      }
    
      try {
        const response: AxiosResponse = await axios.get(url, {
          headers: {
            "Authorization": this.get_access_token(),
          }
        });
    
        this.logRequestAndResponse(url, 'GET', null, response);
        return response.data;
      } catch (error: any) {
        console.error(`Error while performing GET request to ${url}`, error);
    
        if (error.response && (error.response.status === 401 || error.response.status === 422)) {
          window.location.href = '/auth/login'
        }
    
        throw error;
      }
    }
  
    async post(endpoint: string, data: any): Promise<any> {
      const url = `${this.baseURL}/${endpoint}`;
      try {
        const response: AxiosResponse = await axios.post(url, data, {
          headers: {
            "Authorization": this.get_access_token(),
          }
        });
        this.logRequestAndResponse(url, 'POST', data, response);
        return response.data;
      } catch (error: any) {
        console.error(`Error while performing post request to ${url}`, error);
    
        if (error.response && (error.response.status === 401 || error.response.status === 422)) {
          window.location.href = '/auth/login'
        }
    
        throw error;
      }
    }
  
    async put(endpoint: string, data: any): Promise<any> {
      const url = `${this.baseURL}/${endpoint}`;
      try {
        const response: AxiosResponse = await axios.put(url, data, {
          headers: {
            "Authorization": this.get_access_token(),
          }
        });
        this.logRequestAndResponse(url, 'PUT', data, response);
        return response.data;
      } catch (error: any) {
        console.error(`Error while performing PUT request to ${url}`, error);
    
        if (error.response && (error.response.status === 401 || error.response.status === 422)) {
          window.location.href = '/auth/login'
        }
    
        throw error;
      }
    }
  
    async delete(endpoint: string, data: any): Promise<any> {
      const url = `${this.baseURL}/${endpoint}`;
      try {
        const response: AxiosResponse = await axios.delete(url, { data, headers: {
          "Authorization": this.get_access_token(),
        } });
        this.logRequestAndResponse(url, 'DELETE', data, response);
        return response.data;
      } catch (error: any) {
        console.error(`Error while performing DELETE request to ${url}`, error);
    
        if (error.response && (error.response.status === 401 || error.response.status === 422)) {
          window.location.href = '/auth/login'
        }
    
        throw error;
      }
    }
  
    private logRequestAndResponse(url: string, method: string, data: any, response: AxiosResponse) {
      console.log(`Request (${method}): ${url}`);
      console.log('Request data:', data);
      console.log('Response data:', response.data);
    }
  }

class BEAPI extends BaseCommunication
{

    constructor(baseURL: string = "http://172.16.0.3:5000")
    {
        super(baseURL);

    }


    /*
        example usage getUsers('users', 'param1=value1', 'param2=value2');
    */

    async login(telefone: number, password: string)
    {
      let data = await super.post('login', {
        telefone: telefone,
        password: password,
      });
      
      localStorage.setItem('auth-token' , data.access_token)
    }

    async getUsers(): Promise<UTILIZADOR[]>
    {
        return await super.get('users');
    }
    
    async addUser(user: Partial<UTILIZADOR>): Promise<UTILIZADOR>
    {
        return await super.post('users', user);
    }

    async removeUser(Id: number)
    {
      return await super.delete('users/' + Id, null);
    }

    async getUserLastEvents(usr_id: number , nevents: number): Promise<LAST_USER_EVENTS[]>
    {
      return await super.get('user/last_events','user_id='+usr_id,'nevents='+nevents);
    }

    async getUserRestrictedAreas(usr_id: number)
    {
      return await super.get('user/restricted_areas_by_user', 'user_id='+usr_id);
    }

    async getEventsCountByCategory(): Promise<EVENTS_COUNT_BY_CATEGORY[]>
    {
      return await super.get('events/get_events_count_by_category');
    }

    async getNumberOfEventsInExcludedTime(): Promise<NUMBER_STATS[]>
    {
      return await super.get('events/get_number_of_events_in_excluded_time');
    }

    async getNumberOfEventsInMaintenance(): Promise<NUMBER_STATS[]>
    {
      return await super.get('events/get_number_of_events_in_maintenance');
    }

    async getNumberOfEventsInActiveSchedule(): Promise<NUMBER_STATS[]>
    {
      return await super.get('events/get_number_of_events_in_active_schedule');
    }

    async get_next_maintenance(): Promise<NEXT_MAINTENANCE[]>
    {
      return await super.get('events/get_next_maintenance');
    }
}

export const BE_API: BEAPI = new BEAPI();