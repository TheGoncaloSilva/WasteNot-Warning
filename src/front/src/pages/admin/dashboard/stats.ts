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
        
        // Only get the next two
        if (res.length > 10) {
            res.splice(8); // Remove all elements starting from index 2
        }

        return res;
    })();
};