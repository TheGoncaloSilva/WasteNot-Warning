import axios, { AxiosResponse } from 'axios';
import { EVENTS_COUNT_BY_CATEGORY, LAST_USER_EVENTS, UTILIZADOR } from './interfaces';

class BaseCommunication {
    private baseURL: string;
  
    constructor(baseURL: string, logs: boolean = true) {
      this.baseURL = baseURL;
    }


    async get(endpoint: string, ...params: string[]): Promise<any> {
      let url = `${this.baseURL}/${endpoint}`;
  
      // Append query parameters to the URL
      if (params.length > 0) {
        const queryParams = params.join('&');
        url += `?${queryParams}`;
      }
  
      try {
        const response: AxiosResponse = await axios.get(url);
        this.logRequestAndResponse(url, 'GET', null, response);
        return response.data;
      } catch (error) {
        console.error(`Error while performing GET request to ${url}`, error);
        throw error;
      }
    }
  
    async post(endpoint: string, data: any): Promise<any> {
      const url = `${this.baseURL}/${endpoint}`;
      try {
        const response: AxiosResponse = await axios.post(url, data);
        this.logRequestAndResponse(url, 'POST', data, response);
        return response.data;
      } catch (error) {
        console.error(`Error while performing POST request to ${url}`, error);
        throw error;
      }
    }
  
    async put(endpoint: string, data: any): Promise<any> {
      const url = `${this.baseURL}/${endpoint}`;
      try {
        const response: AxiosResponse = await axios.put(url, data);
        this.logRequestAndResponse(url, 'PUT', data, response);
        return response.data;
      } catch (error) {
        console.error(`Error while performing PUT request to ${url}`, error);
        throw error;
      }
    }
  
    async delete(endpoint: string, data: any, headers: any): Promise<any> {
      const url = `${this.baseURL}/${endpoint}`;
      try {
        const response: AxiosResponse = await axios.delete(url, { data, headers });
        this.logRequestAndResponse(url, 'DELETE', data, response);
        return response.data;
      } catch (error) {
        console.error(`Error while performing DELETE request to ${url}`, error);
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
      return await super.delete('users/' + Id, null, null);
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
}

export const BE_API: BEAPI = new BEAPI();