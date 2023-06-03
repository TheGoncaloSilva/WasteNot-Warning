import { BE_API } from '../../../services/backend-api/backend-api';
import { EVENT_LIST, NEXT_MAINTENANCE, NUMBER_STATS } from '../../../services/backend-api/interfaces';

export const getNextMaintenance = async () => {
    return await (async() => {
        const res: NEXT_MAINTENANCE[] = await BE_API.get_next_maintenance();
        
        // Only get the next two
        if (res.length > 2) {
            res.splice(2); // Remove all elements starting from index 2
        }
        return res;
    })();
};

export const getNumberEvents = async () => {
    return await (async() => {
        const res: NUMBER_STATS[] = await BE_API.get_number_of_events();

        return res;
    })();
};

export const getNumberAreasRestritas = async () => {
    return await (async() => {
        const res: NUMBER_STATS[] = await BE_API.get_number_of_areas();
        
        return res;
    })();
};

export const getNumberDevices = async () => {
    return await (async() => {
        const res: NUMBER_STATS[] = await BE_API.get_number_of_devices();
        
        return res;
    })();
};

export const getEventList = async () => {
    return await (async() => {
        const res: EVENT_LIST[] = await BE_API.get_list_events();
        
        if (res.length > 9) {
            res.splice(9);
        }

        return res;
    })();
};

export const getTriggerAlarm = async () => {
    return await (async() => {
        const res: EVENT_LIST[] = await BE_API.get_trigger_alarm();
        
        // Only get the next one
        if (res.length > 1) {
            res.splice(1); // Remove all elements starting from index 1
        }

        return res;
    })();
};

export const get_paginated_Events = async (offset : number, fetch:number, type: string) => {
    return await (async() => {
        let res: EVENT_LIST[]
        if(type == 'all')
            res = await BE_API.get_paginated_Events(offset, fetch);
        else
            res = []

        if (res.length > 9) {
            res.splice(9);
        }

        return res;
    })();
};